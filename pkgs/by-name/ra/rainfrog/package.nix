{
  lib,
  fetchFromGitHub,
  testers,
  nix-update-script,
  rustPlatform,
  rainfrog,
}:
let
  version = "0.3.7";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "rainfrog";

  src = fetchFromGitHub {
    owner = "achristmascarl";
    repo = "rainfrog";
    tag = "v${version}";
    hash = "sha256-6E59Sqe3igXcbd/E11+gOuaJufVV7Ayb0rIX3MCVvPY=";
  };

  cargoHash = "sha256-UTzXm/fToi1HPfX9H+G6o39kc+n9pCbqzfQjvV7IMv4=";

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
