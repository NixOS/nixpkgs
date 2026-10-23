{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "reddix";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "ck-zhang";
    repo = "reddix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4MKRzqsTJxtiAGCvQdAAIMbAcXKwkIth1g1uvQuGXso=";
  };

  cargoHash = "sha256-4R27KeXu7nRA7A7GLbhIf+j5RKnOrOoysoUcZH053ns=";

  checkFlags = [
    # Always pass on local but fail on ofborg
    # Might be a race between load_defaults_without_files and env_overrides
    "--skip=config::tests::load_defaults_without_files"
  ];

  meta = {
    description = "Reddit, refined for the terminal";
    homepage = "https://github.com/ck-zhang/reddix";
    changelog = "https://github.com/ck-zhang/reddix/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "reddix";
    maintainers = with lib.maintainers; [ aleksana ];
  };
})
