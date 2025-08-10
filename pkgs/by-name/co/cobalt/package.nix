{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cobalt";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "cobalt-org";
    repo = "cobalt.rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6WbJjPz+1KX04xMCiylJZiAPjF6jKPTPz7rObgFF4dY=";
  };

  cargoHash = "sha256-Y9+zJ89XrVk3mZD1s9N7oaXvcBP5RNjp3hMjX1Wz3HA=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Static site generator written in Rust";
    homepage = "https://cobalt-org.github.io/";
    downloadPage = "https://github.com/cobalt-org/cobalt.rs/";
    changelog = "https://github.com/cobalt-org/cobalt.rs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    platforms = lib.platforms.unix;
    mainProgram = "cobalt";
  };
})
