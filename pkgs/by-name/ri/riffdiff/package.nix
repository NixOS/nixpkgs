{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  riffdiff,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "riffdiff";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "riff";
    tag = finalAttrs.version;
    hash = "sha256-HODY43et4YYcxp2E7G414auTWh1PSWeAuKRXtltVkU4=";
  };

  cargoHash = "sha256-YhXlMDR8AdLXBKOuC5rF8l0ltrizyeZrN49AaoQwIEc=";

  passthru = {
    tests.version = testers.testVersion { package = riffdiff; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Diff filter highlighting which line parts have changed";
    homepage = "https://github.com/walles/riff";
    changelog = "https://github.com/walles/riff/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      johnpyp
      getchoo
    ];
    mainProgram = "riff";
  };
})
