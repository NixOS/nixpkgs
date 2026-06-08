{
  lib,
  buildPythonApplication,
  fetchPypi,
  hatch-vcs,
  hatchling,
  pynput,
  xdg-base-dirs,
}:

buildPythonApplication (finalAttrs: {
  pname = "bitwarden-menu";
  version = "0.5.3";
  pyproject = true;

  src = fetchPypi {
    pname = "bitwarden_menu";
    inherit (finalAttrs) version;
    hash = "sha256-kLGo+Wg+M2hh1IASKO6WfRmm7p08E6o+1h27ZWxachE=";
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
    changelog = "https://github.com/firecat53/bitwarden-menu/releases/tag/v${finalAttrs.version}";
    description = "Dmenu/Rofi frontend for managing Bitwarden vaults. Uses the Bitwarden CLI tool to interact with the Bitwarden database";
    mainProgram = "bwm";
    homepage = "https://github.com/firecat53/bitwarden-menu";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aman9das ];
  };
})
