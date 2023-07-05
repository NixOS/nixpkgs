{ lib, stdenv, zig }:
argsFun:

let
  wrapDerivation = f:
    stdenv.mkDerivation (finalAttrs:
      f (lib.toFunction argsFun finalAttrs)
    );
in
wrapDerivation (
  { strictDeps ? true
  , nativeBuildInputs ? [ ]
  , meta ? { }
  , ...
  }@attrs:

  attrs // {
    inherit strictDeps;
    nativeBuildInputs = [ zig ] ++ nativeBuildInputs;

    buildPhase = attrs.buildPhase or ''
      runHook preBuild
      export ZIG_GLOBAL_CACHE_DIR=$(mktemp -d)
      zig build -Drelease-safe -Dcpu=baseline $zigBuildFlags
      runHook postBuild
    '';

    checkPhase = attrs.checkPhase or ''
      runHook preCheck
      zig build test
      runHook postCheck
    '';

    installPhase = attrs.installPhase or ''
      runHook preInstall
      zig build -Drelease-safe -Dcpu=baseline $zigBuildFlags --prefix $out install
      runHook postInstall
    '';

    meta = {
      inherit (zig.meta) platforms;
    } // meta;
  }
)
