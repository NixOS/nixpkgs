{
  lib,
  python3,
  fetchFromGitHub,
  xrdb,
}:

# requires openrazer-daemon to be running on the system
# on NixOS hardware.openrazer.enable or pkgs.openrazer-daemon

python3.pkgs.buildPythonApplication rec {
  pname = "razer-cli";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lolei";
    repo = "razer-cli";
    tag = "v${version}";
    hash = "sha256-uwTqDCYmG/5dyse0tF/CPG+9SlThyRyeHJ0OSBpcQio=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = [
    python3.pkgs.openrazer
  ];

  buildInputs = [
    xrdb
  ];

  meta = {
    homepage = "https://github.com/LoLei/razer-cli";
    description = "Command line interface for controlling Razer devices on Linux";
    mainProgram = "razer-cli";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.kaylorben ];
    platforms = lib.platforms.linux;
  };
}
