{
  lib,
  fetchFromGitHub,
  testers,
  nix-update-script,
  rustPlatform,
  rainfrog,
}:
let
  version = "0.3.12";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "rainfrog";

  src = fetchFromGitHub {
    owner = "achristmascarl";
    repo = "rainfrog";
    tag = "v${version}";
    hash = "sha256-4Zc8r6Sf4iE/fYiYwa8gXoCzEnCuarYzF1AzaXhdpHg=";
  };

  cargoHash = "sha256-Ziqs6F3XaWY0ugdpE096/SYmNEeKK4KdrhOkJcKUxZs=";

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
