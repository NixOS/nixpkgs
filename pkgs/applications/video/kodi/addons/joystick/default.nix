{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, tinyxml, udev }:
buildKodiBinaryAddon rec {
  pname = namespace;
  namespace = "peripheral.joystick";
<<<<<<< HEAD
  version = "20.1.9";
=======
  version = "20.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = namespace;
    rev = "${version}-${rel}";
<<<<<<< HEAD
    sha256 = "sha256-xJh9Rj+PcxrgGomEsKnQcO/yZDQCnG6gNBwfK2JGuNA=";
=======
    sha256 = "sha256-LdagiN0bVanmGkAy9APbP1TW68KES7BIy5PXgUzksJQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  extraBuildInputs = [ tinyxml udev ];

  meta = with lib; {
    description = "Binary addon for raw joystick input.";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
