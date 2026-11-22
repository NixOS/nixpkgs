{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "bitwarden-menu";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "bitwarden_menu";
    inherit (finalAttrs) version;
    hash = "sha256-M0OsqvXlJcuClb1Bg9U06wKkPVeGAj6b+0TiUEmTbSg=";
  };

  nativeBuildInputs = with python3Packages; [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = with python3Packages; [
    pynput
    xdg-base-dirs
  ];

  doCheck = false;

  meta = {
    changelog = "https://github.com/firecat53/bitwarden-menu/releases/tag/v${finalAttrs.version}";
    description = "Dmenu/Rofi frontend for managing Bitwarden vaults. Uses the Bitwarden CLI tool to interact with the Bitwarden database";
    mainProgram = "bwm";
    homepage = "https://github.com/firecat53/bitwarden-menu";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aman9das ];
  };
})
