{
  lib,
  python3Packages,
  fetchPypi,
  dmenu,
  wl-clipboard,
}:

python3Packages.buildPythonApplication rec {
  pname = "bitwarden-menu";
  version = "0.4.5";
  pyproject = true;

  src = fetchPypi {
    pname = "bitwarden_menu";
    inherit version;
    hash = "sha256-vUlNqSVdGhfN5WjDjf1ub32Y2WoBndIdFzfCNwo5+Vg=";
  };

  patches = [ ./fix-circular-imports.patch ];

  build-system = with python3Packages; [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    dmenu
    wl-clipboard
  ]
  ++ (with python3Packages; [
    pynput
    xdg-base-dirs
  ]);

  doCheck = false;

  meta = {
    changelog = "https://github.com/firecat53/bitwarden-menu/releases/tag/v${version}";
    description = "Dmenu/Rofi frontend for managing Bitwarden vaults. Uses the Bitwarden CLI tool to interact with the Bitwarden database";
    mainProgram = "bwm";
    homepage = "https://github.com/firecat53/bitwarden-menu";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aman9das ];
  };
}
