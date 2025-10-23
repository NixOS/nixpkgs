{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  riffdiff,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "riffdiff";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "riff";
    tag = version;
    hash = "sha256-qA20sLiGqDtIPWBNww+WXM5AG162RPTdkUPoJ0PLiYY=";
  };

  cargoHash = "sha256-omwKOstRXIAUDgLUFqmtxu77JJzAOASzbjLEImad1cE=";

  passthru = {
    tests.version = testers.testVersion { package = riffdiff; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Diff filter highlighting which line parts have changed";
    homepage = "https://github.com/walles/riff";
    changelog = "https://github.com/walles/riff/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      johnpyp
      getchoo
    ];
    mainProgram = "riff";
  };
}
