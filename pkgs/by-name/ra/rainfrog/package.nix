{
  lib,
  fetchFromGitHub,
  testers,
  nix-update-script,
  rustPlatform,
  rainfrog,
}:
let
  version = "0.3.15";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "rainfrog";

  src = fetchFromGitHub {
    owner = "achristmascarl";
    repo = "rainfrog";
    tag = "v${version}";
    hash = "sha256-XW2jMiQif0Q9IV8rDw44n/7OTfPkO+XpAb0AVobddDM=";
  };

  cargoHash = "sha256-+B5hPtgXoe3mNiOsarivk8sZ6RS6re3Cw/LO4fzuX9o=";

  passthru = {
    tests.version = testers.testVersion {
      package = rainfrog;

      command = ''
        RAINFROG_DATA="$(mktemp -d)" rainfrog --version
      '';
    };

    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/achristmascarl/rainfrog/releases/tag/v${version}";
    description = "Database management TUI for postgres";
    homepage = "https://github.com/achristmascarl/rainfrog";
    license = lib.licenses.mit;
    mainProgram = "rainfrog";
    maintainers = with lib.maintainers; [ patka ];
  };
}
