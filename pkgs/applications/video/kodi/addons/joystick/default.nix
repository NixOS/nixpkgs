{
  lib,
  rel,
  buildKodiBinaryAddon,
  fetchFromGitHub,
  tinyxml,
  udev,
}:
buildKodiBinaryAddon rec {
  pname = namespace;
  namespace = "peripheral.joystick";
  version = "21.1.23";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = namespace;
    rev = "${version}-${rel}";
    sha256 = "sha256-ADkXvbTsx4xMUiu90hvHIMvpAF0FQ2HNkKDX/E/tRok=";
  };

  extraBuildInputs = [
    tinyxml
    udev
  ];

  meta = {
    description = "Binary addon for raw joystick input";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl2Only;
    teams = [ lib.teams.kodi ];
  };
}
