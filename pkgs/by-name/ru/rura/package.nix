{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rura";
  version = "1.9.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tlipinski";
    repo = "rura";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+XfJc9FH9El36AL7s7wMy9TNILKvtYflRDZjeW9J3fg=";
  };

  cargoHash = "sha256-HBcKuQjRqVBItgIVUyNQiqfZxNVtyQgwr+5mTrlV3eM=";

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Interactive TUI scratchpad for building shell pipelines";
    homepage = "https://github.com/tlipinski/rura";
    changelog = "https://github.com/tlipinski/rura/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ frantathefranta ];
    mainProgram = "rura";
  };
})
