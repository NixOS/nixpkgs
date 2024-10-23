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
  version = "2024-04-04";

  src = fetchFromGitHub {
    owner = "lolei";
    repo = pname;
    rev = "e4c9a93f012fea2362e18c3374a38bc77a62d86b";
    hash = "sha256-HWEYcYYHQs2uZZtiK+BaKU2yc90dJ+FEbR+ohq0Wkpw=";
  };

  propagatedBuildInputs = [
    python3.pkgs.openrazer
    xrdb
  ];

  meta = with lib; {
    homepage = "https://github.com/LoLei/razer-cli";
    description = "Command line interface for controlling Razer devices on Linux";
    mainProgram = "razer-cli";
    license = licenses.gpl3;
    maintainers = [ maintainers.kaylorben ];
  };
}
