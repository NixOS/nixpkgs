{
  lib,
  fetchFromGitHub,
  gitMinimal,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fallow";
  version = "2.65.0";

  src = fetchFromGitHub {
    owner = "fallow-rs";
    repo = "fallow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MhQMbS6/zxcVzcUOM1sMs2ECAfwVvXt/U8irfUF2ZlU=";
  };

  cargoHash = "sha256-EczmP2z5haocsok84LJDUTqbqjvbuCfFwFrTGy3tH/c=";

  buildAndTestSubdir = "crates/cli";

  nativeCheckInputs = [
    gitMinimal
  ];

  preCheck = ''
    # Some integration tests create temporary fixture projects and expect Git
    # discovery to find a parent repository for hotspot analysis.
    git init "$TMPDIR"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rust-native codebase intelligence for TypeScript and JavaScript";
    homepage = "https://docs.fallow.tools";
    changelog = "https://github.com/fallow-rs/fallow/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bartwaardenburg ];
    mainProgram = "fallow";
  };
})
