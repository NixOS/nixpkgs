{
  lib,
  rustPlatform,
  openssl,
  pkg-config,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "glues";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "gluesql";
    repo = "glues";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2GCFn0TiWZ2xtxfBHq17UoLBxqsCFWa9YnzWJTUd9Z8=";
  };

  cargoHash = "sha256-Vw7AtM8I7tH9WAHsZmi8Igb/dPT+4z/Hn9cOGlNBCfs=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Vim-inspired TUI note-taking app with multi-backend storage — privacy-focused";
    homepage = "https://gluesql.org/glues/";
    downloadPage = "https://github.com/gluesql/glues";
    changelog = "https://github.com/gluesql/glues/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "glues";
  };
})
