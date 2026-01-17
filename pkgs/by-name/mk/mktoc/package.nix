{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mktoc";
  version = "5.1.1";

  src = fetchFromGitHub {
    owner = "KevinGimbel";
    repo = "mktoc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EyQrfLpeWacAEpVnaz4alEF/IAjSH/4HsTsdJldOJxg=";
  };

  cargoHash = "sha256-yTTJ0gxmQhn40eI+Elzvv/t0WLivI0TV8B/LS6KLg14=";

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
