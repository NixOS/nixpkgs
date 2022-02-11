{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, tinyxml, udev }:
buildKodiBinaryAddon rec {
  pname = namespace;
  namespace = "peripheral.joystick";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = namespace;
    rev = "${version}-${rel}";
    sha256 = "1dhj4afr9kj938xx70fq5r409mz6lbw4n581ljvdjj9lq7akc914";
  };

  extraBuildInputs = [ tinyxml udev ];

  meta = with lib; {
    description = "Binary addon for raw joystick input.";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
