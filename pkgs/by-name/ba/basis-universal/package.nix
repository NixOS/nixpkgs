{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "basis-universal";
  version = "1.60.0";

  src = fetchFromGitHub {
    owner = "BinomialLLC";
    repo = "basis_universal";
    # TODO: Compute from version
    # TODO: Upstream PR
    rev = "e2f294d148207ac39e0a229d0a831601b4d9dc8a";
    hash = "sha256-hGmCusbs7mtPfmVo2iFMrNZ6e7OBGbLgK6cvDjaQdFs=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];
  nativeCheckHooks = [
    versionCheckHook
  ];

  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Basis Universal GPU Texture Codec";
    homepage = "https://github.com/BinomialLLC/basis_universal";
    license = lib.licenses.asl20;
    mainProgram = "basisu";
    maintainers = with lib.maintainers; [ pandapip1 ];
    platforms = lib.platforms.all;
  };
})
