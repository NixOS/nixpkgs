{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mktoc";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "KevinGimbel";
    repo = "mktoc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QiV0lPM5rRAVH+a15f3G8quoa26I8jHEvbtfTQU5FKM=";
  };

  cargoHash = "sha256-Ny9g1TQUSGOBocFtzmxfFZp5K8t7z3JlEMHBTi69bLU=";

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
