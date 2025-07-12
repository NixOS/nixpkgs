{
  callPackage,
  stdenvNoCC,
  lib,
}:
let
  inherit (callPackage ./jsr/transform-files-jsr-and-https.nix { }) transformJsrAndHttpsPackages;
  inherit (callPackage ./npm/transform-files-npm.nix { }) transformNpmPackages;
  inherit (callPackage ./lib.nix { }) buildHelperFetcher toPackagesFilesList;

  inherit (callPackage ./jsr/transform-lock-jsr.nix { }) makeJsrPackages;
  inherit (callPackage ./https/transform-lock-https.nix { }) makeHttpsPackages;
  inherit (callPackage ./npm/transform-lock-npm.nix { }) makeNpmPackages;
  inherit (callPackage ./parse-specifier.nix { }) parsePackageSpecifier;

  transformDenoLockV5 =
    denoLockParsed: topLevelHash:
    let
      jsrParsed = builtins.mapAttrs (name: value: {
        parsedPackageSpecifier = (parsePackageSpecifier name);
        hash = value.integrity;
      }) denoLockParsed.jsr;
      jsrPackages = lib.attrsets.optionalAttrs (builtins.hasAttr "jsr" denoLockParsed) (makeJsrPackages {
        inherit jsrParsed;
      });

      httpsParsed = denoLockParsed.remote;
      httpsPackages = lib.attrsets.optionalAttrs (builtins.hasAttr "remote" denoLockParsed) (
        let
          httpsPackages' = (
            makeHttpsPackages {
              inherit httpsParsed;
            }
          );
        in
        httpsPackages'
        // {
          withOneHash = httpsPackages'.withOneHash // {
            hash = topLevelHash;
          };
        }
      );
      npmParsed = builtins.mapAttrs (name: value: {
        parsedPackageSpecifier = parsePackageSpecifier name;
        hash = value.integrity;
      }) denoLockParsed.npm;
      npmPackages = lib.attrsets.optionalAttrs (builtins.hasAttr "npm" denoLockParsed) (makeNpmPackages {
        inherit npmParsed;
      });
    in
    {
      jsr = jsrPackages;
      https = httpsPackages;
      npm = npmPackages;
    };

  transformDenoLock =
    { denoLock, hash }:
    let
      denoLockParsed = builtins.fromJSON (builtins.readFile denoLock);
      transformers = {
        "5" = transformDenoLockV5;
        "4" = transformDenoLockV5;
        "default" =
          assert (lib.assertMsg false "deno lock version not supported");
          null;
      };
    in
    if builtins.hasAttr denoLockParsed.version transformers then
      transformers."${denoLockParsed.version}" denoLockParsed hash
    else
      transformers."default";

  # https://github.com/denoland/deno_cache_dir/blob/0.23.0/rs_lib/src/local.rs#L802
  keepHeaders = [
    "content-type"
    "location"
    "x-deno-warning"
    "x-typescript-types"
  ];

in
{
  fetchDenoDeps =
    {
      denoLock,
      name ? "deno-deps",
      hash ? lib.fakeHash,
      denoDir ? ".deno",
      vendorDir ? "vendor",
      impureEnvVars ? "",
      oneHashFetcherArgs ? { },
      fetchurlArgs ? { },
    }:
    let
      transformedDenoLock = transformDenoLock { inherit denoLock hash; };

      fetched = builtins.mapAttrs (
        name: value:
        buildHelperFetcher {
          inherit
            impureEnvVars
            oneHashFetcherArgs
            fetchurlArgs
            keepHeaders
            ;
          packages = transformedDenoLock."${name}";
        }
      ) transformedDenoLock;

      transformedPackages =
        let
          jsrAndHttpsFiles =
            (lib.optionals (fetched ? "jsr") (toPackagesFilesList fetched.jsr))
            ++ (lib.optionals (fetched ? "https") (toPackagesFilesList fetched.https));
          npmFiles = lib.optionals (fetched ? "npm") (toPackagesFilesList fetched.npm);
        in
        {
          jsrAndHttps =
            if jsrAndHttpsFiles != [ ] then
              (transformJsrAndHttpsPackages {
                inherit vendorDir denoDir;
                allFiles = jsrAndHttpsFiles;
              }).transformed
            else
              "";
          npm =
            if npmFiles != [ ] then
              transformNpmPackages {
                inherit name denoDir;
                allFiles = toPackagesFilesList fetched.npm;
              }
            else
              "";
        };

      final = stdenvNoCC.mkDerivation {
        inherit name;

        src = null;
        unpackPhase = "true";

        buildPhase = ''
          mkdir -p $out;
          if [[ -d ${transformedPackages.jsrAndHttps}/${vendorDir} ]]; then
            cp -r ${transformedPackages.jsrAndHttps}/${vendorDir} $out;
          fi
          if [[ -d ${transformedPackages.npm}/${denoDir} ]]; then
            cp -r ${transformedPackages.npm}/${denoDir} $out;
          fi
          cp ${denoLock} $out;
        '';
      };
    in
    {
      inherit
        transformedDenoLock
        fetched
        transformedPackages
        final
        ;
    };
}
