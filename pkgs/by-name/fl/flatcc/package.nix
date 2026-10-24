{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flatcc";
  version = "0.6.4";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "dvidelabs";
    repo = "flatcc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J3vw7DYhaYD7QVChcNElKCYoh0cwGJj2hr5ugcIcZZw=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "FLATCC_INSTALL" true)
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "FlatBuffers Compiler and Library in C for C";
    mainProgram = "flatcc";
    homepage = "https://github.com/dvidelabs/flatcc";
    changelog = "https://github.com/dvidelabs/flatcc/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ onny ];
  };
})
