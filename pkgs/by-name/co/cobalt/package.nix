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
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "cobalt-org";
    repo = "cobalt.rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0MwIJJ7oNUFMNqMzew9HgaZsfBNczBli20vsxtIWZq0=";
  };

  cargoHash = "sha256-4oLEInL5hocCkP20lrOzfwPm5ram8Xw6p1qSva1tzNQ=";

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
