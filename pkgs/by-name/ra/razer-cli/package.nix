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
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lolei";
    repo = "razer-cli";
    rev = "v${version}";
    hash = "sha256-p/RcBpkvtqYQ3Ekt0pLvKyi1Vv93oHDd7hqSTu/5CSw=";
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
