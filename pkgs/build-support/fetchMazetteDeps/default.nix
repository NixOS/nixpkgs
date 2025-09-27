{
  stdenv,
  lib,
  mazette,
}:

{
  mazettefile,
  lockfile,
  hash,
}:

let
  hash_ =
    if hash != "" then
      {
        outputHashAlgo = null;
        outputHash = hash;
      }
    else
      {
        outputHashAlgo = "sha256";
        outputHash = lib.fakeSha256;
      };
in
stdenv.mkDerivation (
  {
    name = "mazette-cache";
    outputHashMode = "recursive";

    dontUnpack = true;
    dontInstall = true;
    dontFixup = true;

    nativeBuildInputs = [ mazette ];

    inherit mazettefile lockfile;

    buildPhase = ''
      runHook preBuild

      export XDG_CACHE_HOME=$NIX_BUILD_TOP/.cache
      mkdir -p $XDG_CACHE_HOME
      cp $mazettefile $lockfile .
      mazette install
      mv $XDG_CACHE_HOME $out

      runHook postBuild
    '';
  }
  // hash_
)
