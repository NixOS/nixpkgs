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
  version = "20.1.9";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = namespace;
    rev = "${version}-${rel}";
    sha256 = "sha256-xJh9Rj+PcxrgGomEsKnQcO/yZDQCnG6gNBwfK2JGuNA=";
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
