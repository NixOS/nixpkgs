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
          --in-path ${denoLock} \
          --out-path-jsr $out/jsr.json \
          --out-path-npm $out/npm.json \
          --out-path-https $out/https.json;
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
      vendorJsonName,
      npmJsonName,
      denoLock,
      hash,
      name,
    }:
    stdenvNoCC.mkDerivation {
      inherit name;
      src = null;
      unpackPhase = "true";
      buildPhase = ''
        single-fod-fetcher \
          --in-path-jsr ${transformedDenoLock}/jsr.json \
          --in-path-npm ${transformedDenoLock}/npm.json \
          --in-path-https ${transformedDenoLock}/https.json \
          --out-path-prefix $out \
          --out-path-vendored ${vendorJsonName} \
          --out-path-npm ${npmJsonName};
        cp ${denoLock} $out/deno.lock
      '';
      nativeBuildInputs = [
        fetch-deno-deps-scripts
      ];

      SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

      outputHashMode = "recursive";
      outputHash = hash;
      outputHashAlgo = "sha256";

      meta = {
        maintainers = [ lib.maintainers.aMOPel ];
      };
    };

  # this derivation only meant to be used, if the dependency dir is needed outside of buildDenoPackage
  transformedFiles =
    {
      fetched,
      name,
      vendorJsonName,
      npmJsonName,
      denoDir,
      vendorDir,
    }:
    stdenvNoCC.mkDerivation {
      name = "denoDeps-final-${name}";

      src = null;
      unpackPhase = "true";

      inherit
        npmJsonName
        vendorJsonName
        ;

      nativeBuildInputs = [
        fetch-deno-deps-scripts
        file-structure-transformer-vendor
      ];
      buildPhase = ''
        export vendorDir="$out/${vendorDir}";
        export DENO_DIR="$out/${denoDir}";
        mkdir -p $DENO_DIR
        mkdir -p $vendorDir
        file-structure-transformer-npm --in-path "${fetched}/$npmJsonName" --cache-path $DENO_DIR
        file-structure-transformer-vendor --cache-path $DENO_DIR --vendor-path $vendorDir --url-file-map "${fetched}/$vendorJsonName"
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
      vendorJsonName ? "vendor.json",
      npmJsonName ? "npm.json",
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
          vendorJsonName
          npmJsonName
          name
          ;
      };

      denoDeps = transformedFiles {
        inherit
          fetched
          name
          vendorJsonName
          npmJsonName
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
