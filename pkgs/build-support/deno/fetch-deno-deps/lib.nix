{
  stdenvNoCC,
  curl,
  cacert,
  lib,
  fetchurl,
  breakpointHook,
}:
let
  urlToPath = url: builtins.hashString "sha256" url;

  addOutPath = root: file: file // { outPath = "${root}/${urlToPath file.url}"; };

  headersToRegex =
    headers: builtins.concatStringsSep ''\|'' (builtins.map (header: "^${header}:") headers);

  makeCurlCommand =
    { file, keepHeaders }:
    let
      filePath = urlToPath file.url;
      headersRegex = headersToRegex keepHeaders;
      hasHeaders = keepHeaders != [ ];
      keepHeadersCurlFlag = lib.optionalString hasHeaders "-D $out/${filePath}-headers";
      filterHeadersScript = lib.optionalString hasHeaders ''
        cat $out/${filePath}-headers | grep -i '${headersRegex}' > temp;
        cat temp > "$out/${filePath}-headers" ;
      '';
      curlOpts = lib.optionalString (file ? "curlOpts") file.curlOpts;
      curlOptsList = builtins.toString (lib.optionals (file ? "curlOptsList") file.curlOptsList);
    in
    ''
      newcurl=("''${curl[@]}")
      curlOpts="${curlOpts}";
      curlOptsList="${curlOptsList}";
      keepHeaders="${keepHeadersCurlFlag}";
      eval "newcurl+=($curlOptsList)";
      newcurl+=(
          $curlOpts
          $keepHeaders
      );
      "''${newcurl[@]}" -C - --fail "${file.url}" --output $out/"${filePath}";
    ''
    + filterHeadersScript;

  makeCurlCommands =
    { packagesFiles, keepHeaders }:
    builtins.concatStringsSep "\n" (
      builtins.map (file: makeCurlCommand { inherit file keepHeaders; }) packagesFiles
    );

  fixHash =
    { hash, algo }:
    let
      hashWithoutPrefix = lib.lists.last (lib.strings.splitString "-" hash);
      hash' = builtins.convertHash {
        hash = hashWithoutPrefix;
        toHashFormat = "sri";
        hashAlgo = algo;
      };
    in
    hash';

  oneHashFetcher =
    {
      impureEnvVars ? [ ],
      keepHeaders ? [ ],
      withOneHash,
      oneHashFetcherArgs,
    }:
    let
      curlOpts = lib.optionalString (withOneHash ? "curlOpts") withOneHash.curlOpts;
      curlOptsList = lib.optionals (withOneHash ? "curlOptsList") (
        lib.escapeShellArgs withOneHash.curlOptsList
      );
      derivation =
        stdenvNoCC.mkDerivation {
          name = "build-helper-fetcher-one-hash";

          inherit
            curlOptsList
            curlOpts
            ;

          src = null;
          unpackPhase = "true";

          nativeBuildInputs = [
            curl
            breakpointHook
          ];
          buildPhase =
            ''
              mkdir -p $out;

              curlVersion=$(curl -V | head -1 | cut -d' ' -f2)

              # Curl flags to handle redirects, not use EPSV, handle cookies for
              # servers to need them during redirects, and work on SSL without a
              # certificate (this isn't a security problem because we check the
              # cryptographic hash of the output anyway).
              curl=(
                  curl
                  --location
                  --max-redirs 20
                  --retry 3
                  --retry-all-errors
                  --continue-at -
                  --disable-epsv
                  --cookie-jar cookies
                  --user-agent "curl/$curlVersion Nixpkgs/$nixpkgsVersion"
              )

              if ! [ -f "$SSL_CERT_FILE" ]; then
                  curl+=(--insecure)
              fi

              eval "curl+=($curlOptsList)"

              curl+=(
                  $curlOpts
                  $NIX_CURL_FLAGS
              )

            ''
            + (makeCurlCommands {
              inherit keepHeaders;
              inherit (withOneHash) packagesFiles;
            });

          impureEnvVars =
            lib.fetchers.proxyImpureEnvVars
            ++ [
              # This variable allows the user to pass additional options to curl
              "NIX_CURL_FLAGS"
            ]
            ++ impureEnvVars;

          SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

          outputHashMode = "recursive";
          outputHash = withOneHash.hash;
          outputHashAlgo = "sha256";
        }
        // oneHashFetcherArgs;

      packagesFiles' = builtins.map (addOutPath "${derivation}") withOneHash.packagesFiles;
    in
    withOneHash
    // {
      inherit derivation;
      packagesFiles = packagesFiles';
    };

  fetchPackageFile =
    {
      file,
      impureEnvVars,
      fetchurlArgs,
    }:
    let
      derivation =
        fetchurl {
          url = file.url;
          hash = file.hash;
          netrcImpureEnvVars = impureEnvVars;
        }
        // fetchurlArgs;
    in
    file
    // {
      inherit derivation;
      outPath = "${derivation}";
    };

  toPackagesFilesList =
    packages:
    (lib.optionals (packages ? preFetched) packages.preFetched.packagesFiles)
    ++ (lib.optionals (packages ? withOneHash) packages.withOneHash.packagesFiles)
    ++ (lib.optionals (packages ? withHashPerFile) packages.withHashPerFile.packagesFiles);

  ## merges a list of packages
  ## `[ { withHashPerFile = ...; withOneHash = ...; } { withHashPerFile = ...; withOneHash = ...; } ... ]`
  ## to a single packages object `{ withHashPerFile = ...; withOneHash = ...; }`
  mergePackagesList =
    packagesList:
    let
      merge =
        key:
        builtins.concatLists (
          builtins.map (
            packages: lib.attrsets.attrByPath [ "${key}" "packagesFiles" ] [ ] packages
          ) packagesList
        );
    in
    builtins.mapAttrs (name: value: { packagesFiles = merge name; }) {
      preFetched = null;
      withHashPerFile = null;
      withOneHash = null;
    };

  buildHelperFetcher =
    {
      packages,
      impureEnvVars ? "",
      oneHashFetcherArgs ? { },
      fetchurlArgs ? { },
      keepHeaders ? [ ],
    }:
    let
      hasWithHashPerFile = packages ? withHashPerFile;
      hasWithOneHash = packages ? withOneHash;
      hasTopLevelHash = packages.withOneHash ? hash;
      hasPackages = packages.withOneHash.packagesFiles != { };

      withSingleFod = lib.optionalAttrs (hasWithOneHash && hasTopLevelHash && hasPackages) {
        withOneHash = oneHashFetcher {
          inherit impureEnvVars oneHashFetcherArgs keepHeaders;
          inherit (packages) withOneHash;
        };
      };
      withFodPerFile = lib.optionalAttrs hasWithHashPerFile {
        withHashPerFile = packages.withHashPerFile // {
          packagesFiles = builtins.map (
            file: fetchPackageFile { inherit file impureEnvVars fetchurlArgs; }
          ) packages.withHashPerFile.packagesFiles;
        };
      };

    in
    packages // withSingleFod // withFodPerFile;

in
{
  inherit
    buildHelperFetcher
    urlToPath
    fixHash
    toPackagesFilesList
    mergePackagesList
    ;
}
