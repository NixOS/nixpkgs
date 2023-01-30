{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, tinyxml, udev }:
buildKodiBinaryAddon rec {
  pname = namespace;
  namespace = "peripheral.joystick";
  version = "19.0.1";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = namespace;
    rev = "${version}-${rel}";
    sha256 = "sha256-jSz0AgxhbCIbbZJxm4oq22y/hqew949UsqEAPoqEnHA=";
  };

  extraBuildInputs = [ tinyxml udev ];

  meta = with lib; {
    description = "Binary addon for raw joystick input.";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
