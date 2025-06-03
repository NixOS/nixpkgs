{
  lib,
  buildPythonApplication,
  fetchPypi,
  hatch-vcs,
  hatchling,
  pynput,
  xdg-base-dirs,
}:

buildPythonApplication rec {
  pname = "bitwarden-menu";
  version = "0.4.5";
  pyproject = true;

  src = fetchPypi {
    pname = "bitwarden_menu";
    inherit version;
    hash = "sha256-vUlNqSVdGhfN5WjDjf1ub32Y2WoBndIdFzfCNwo5+Vg=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    pynput
    xdg-base-dirs
  ];

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
