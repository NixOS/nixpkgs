{
  callPackage,
  stdenvNoCC,
  lib,
  cacert,
}:
let
  inherit (callPackage ./scripts/deno/default.nix { }) fetch-deno-deps-scripts;

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
    };

in
{
  fetchDenoDeps =
    {
      denoLock,
      name ? "deno-deps",
      hash ? lib.fakeHash,
      vendorJsonName,
      npmJsonName,
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
    in
    {
      inherit
        transformedDenoLock
        fetched
        ;
    };
}
