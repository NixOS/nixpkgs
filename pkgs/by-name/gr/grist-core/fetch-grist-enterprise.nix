{
  lib,
  stdenv,
  cacert,
  curl,

  fetchYarnDeps,
}:
{
  gristSrc,
  version,
  hash,
  offlineCacheHash,
}:
rec {
  src = stdenv.mkDerivation (finalAttrs: {
    pname = "grist-enterprise-src";
    inherit version;

    src = gristSrc;

    phases = [
      "buildPhase"
      "installPhase"
    ];

    nativeBuildInputs = [
      curl
      cacert
    ];

    buildPhase = ''
      ref=$(cat $src/buildtools/.grist-ee-version)

      echo "Found grist-ee version: $ref"

      curl "https://grist-static.com/ext/ext-built-''${ref}.tar.gz" -o ./tarball.tar.gz

    '';
    installPhase = ''
      mkdir -p $out

      tar -xvf ./tarball.tar.gz -C $out
    '';

    outputHash = hash;
    outputHashAlgo = if finalAttrs.outputHash == "" then "sha256" else null;
    outputHashMode = "recursive";
  });
  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/ext/yarn.lock";
    hash = offlineCacheHash;
  };
}
