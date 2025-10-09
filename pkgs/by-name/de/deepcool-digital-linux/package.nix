{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libudev-zero,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "deepcool-digital-linux";
  version = "0.8.3-alpha";

  src = fetchFromGitHub {
    owner = "Nortank12";
    repo = "deepcool-digital-linux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Whmjd6NCOUkE7hM3FaN7grMwcC/suL7AJDVSgnZSKzM=";
  };

  cargoHash = "sha256-K1pEbUyENPUS4QK0lztWmw8ov1fGrx8KHdODmSByfek=";

  buildInputs = [ libudev-zero ];

  nativeBuildInputs = [
    pkg-config
  ];

  doInstallCheck = false; # FIXME: version cmd returns 0.8.3, set to true when we switch to a stable version
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/Nortank12/deepcool-digital-linux/releases/tag/v${finalAttrs.version}";
    description = "Linux version for the DeepCool Digital Windows software";
    homepage = "https://github.com/Nortank12/deepcool-digital-linux";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ NotAShelf ];
    mainProgram = "deepcool-digital-linux";
    platforms = lib.platforms.linux;
  };
})
