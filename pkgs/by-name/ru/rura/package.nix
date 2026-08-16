{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rura";
  version = "1.11.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tlipinski";
    repo = "rura";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oPvO6oCefkyCkhpidfyQzW4ckN2cxSKijdWlKjWc6PU=";
  };

  cargoHash = "sha256-V69RoAhk3Q7RmlgOEhLsoVHofGxY8aT/iZHoWEv47qw=";

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
