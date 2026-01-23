{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shore";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "MoonKraken";
    repo = "shore";
    tag = finalAttrs.version;
    hash = "sha256-K9GKMijLU1ii5O8P4fT5Vl3S3HoVmvcUyCiIC69dTdU=";
  };

  cargoHash = "sha256-HYdTODIHA1TGhu6BKrKFkvBlGtqVt89wYX9Ehn0EOC0=";

  env.OPENSSL_NO_VENDOR = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "CLI-based frontend for inference providers with vim inspired keybindings";
    homepage = "https://github.com/MoonKraken/shore";
    changelog = "https://github.com/MoonKraken/shore/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "shore";
  };
})
