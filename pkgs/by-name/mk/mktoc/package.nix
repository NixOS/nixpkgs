{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mktoc";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "KevinGimbel";
    repo = "mktoc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Pq4o0t0cUrkXff+qSU5mlDo5A0nhFBuFk3Xz10AWDeo=";
  };

  cargoHash = "sha256-SdwNXstW61Yvp1V72nxl+9dijGJwyrdPYZo+q0UGYGg=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Markdown Table of Content generator";
    homepage = "https://github.com/KevinGimbel/mktoc";
    license = lib.licenses.mit;
    mainProgram = "mktoc";
    maintainers = with lib.maintainers; [ kevingimbel ];
  };
})
