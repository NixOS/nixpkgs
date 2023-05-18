{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, tinyxml, udev }:
buildKodiBinaryAddon rec {
  pname = namespace;
  namespace = "peripheral.joystick";
  version = "20.1.0";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = namespace;
    rev = "${version}-${rel}";
    sha256 = "sha256-LdagiN0bVanmGkAy9APbP1TW68KES7BIy5PXgUzksJQ=";
  };

  extraBuildInputs = [ tinyxml udev ];

  meta = with lib; {
    description = "Binary addon for raw joystick input.";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
