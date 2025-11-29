{
  callPackage,
  stdenvNoCC,
  lib,
  cacert,
}:
let
  inherit (callPackage ./scripts/deno/default.nix { }) fetch-deno-deps-scripts;
  inherit (callPackage ./scripts/rust/file-structure-transformer-vendor/default.nix { })
    file-structure-transformer-vendor
    ;

  transformDenoLock =
    {
      denoLock,
    }:
    stdenvNoCC.mkDerivation {
      name = "transformed-deno-lock";
      src = null;
      unpackPhase = "true";
      buildPhase = ''
        mkdir -p $out
        lockfile-transformer \
          --deno-lock-path ${denoLock} \
          --common-lock-jsr-path $out/jsr.json \
          --common-lock-npm-path $out/npm.json \
          --common-lock-https-path $out/https.json;
      '';
      nativeBuildInputs = [
        fetch-deno-deps-scripts
      ];

      meta = {
        maintainers = [ lib.maintainers.aMOPel ];
      };
    };

  singleFodFetcher =
    {
      transformedDenoLock,
      denoLock,
      hash,
      name,
    }:
    let
      args = {
        src = null;
        unpackPhase = "true";
        buildPhase = ''
          single-fod-fetcher \
            --common-lock-jsr-path ${transformedDenoLock}/jsr.json \
            --common-lock-npm-path ${transformedDenoLock}/npm.json \
            --common-lock-https-path ${transformedDenoLock}/https.json \
            --out-path-prefix $out;
          cp ${denoLock} $out/deno.lock
        '';
        nativeBuildInputs = [
          fetch-deno-deps-scripts
        ];
      };
    in
    stdenvNoCC.mkDerivation (
      args
      // {
        name = "${builtins.hashString "sha1" (builtins.toJSON args)}-${name}";
        SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

        outputHashMode = "recursive";
        outputHash = hash;
        outputHashAlgo = "sha256";

        meta = {
          maintainers = [ lib.maintainers.aMOPel ];
        };
      }
    );

  # this derivation only meant to be used, if the dependency dir is needed outside of buildDenoPackage
  transformedFiles =
    {
      fetched,
      name,
      denoDir,
      vendorDir,
    }:
    stdenvNoCC.mkDerivation {
      name = "denoDeps-final-${name}";

      src = null;
      unpackPhase = "true";

      nativeBuildInputs = [
        fetch-deno-deps-scripts
        file-structure-transformer-vendor
      ];
      buildPhase = ''
        export vendorDir="$out/${vendorDir}";
        export DENO_DIR="$out/${denoDir}";
        mkdir -p $DENO_DIR;
        mkdir -p $vendorDir;
        file-structure-transformer-npm \
          --deno-dir-path $DENO_DIR \
          --common-lock-npm-path "${fetched}/npm.json";
        file-structure-transformer-vendor \
          --deno-dir-path $DENO_DIR \
          --vendor-dir-path $vendorDir \
          --common-lock-jsr-path "${fetched}/jsr.json" \
          --common-lock-https-path "${fetched}/https.json";
      '';

      meta = {
        maintainers = [ lib.maintainers.aMOPel ];
      };
    };

in
{
  fetchDenoDeps =
    {
      denoLock,
      name ? "deno-deps",
      hash ? lib.fakeHash,
      denoDir ? ".deno",
      vendorDir ? "vendor",
    }:
    let
      transformedDenoLock = transformDenoLock { inherit denoLock; };

      fetched = singleFodFetcher {
        inherit
          denoLock
          transformedDenoLock
          hash
          name
          ;
      };

      denoDeps = transformedFiles {
        inherit
          fetched
          name
          denoDir
          vendorDir
          ;
      };
    in
    {
      inherit
        transformedDenoLock
        fetched
        denoDeps
        ;
    };
}
