{ lib
, buildPythonApplication
, python3Packages
, fetchPypi
, pynput
, xdg-base-dirs
}:

buildPythonApplication rec {
  pname = "bitwarden-menu";
  version = "0.4.3";
  format = "pyproject";

  src = fetchPypi {
    pname = "bitwarden_menu";
    inherit version;
    hash = "sha256-tuIolWvQ/vKSJr6oUTL7ZLPgdkYsIZods5yQNNfWbWY=";
  };

  nativeBuildInputs = with python3Packages; [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    pynput
    xdg-base-dirs
  ];

  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/firecat53/bitwarden-menu/releases/tag/v${version}";
    description = "Dmenu/Rofi frontend for managing Bitwarden vaults. Uses the Bitwarden CLI tool to interact with the Bitwarden database.";
    mainProgram = "bwm";
    homepage = "https://github.com/firecat53/bitwarden-menu";
    license = licenses.mit;
    maintainers = with maintainers; [ aman9das ];
  };
}
