{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub
, xz, pugixml, zlib
, inputstream-adaptive, inputstream-ffmpegdirect, inputstream-rtmp
}:

buildKodiBinaryAddon rec {
  pname = "pvr-iptvsimple";
  namespace = "pvr.iptvsimple";
<<<<<<< HEAD
  version = "20.11.0";
=======
  version = "20.6.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kodi-pvr";
    repo = "pvr.iptvsimple";
    rev = "${version}-${rel}";
<<<<<<< HEAD
    sha256 = "sha256-58Dma0UtD6Uy4zu4aQT2FY0emLiQpA4RChhnneMzFZI=";
=======
    sha256 = "sha256-fJDMxNDXDijPL0sg86LB6nYQwjTdInf3dyOr8Lkydmg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  extraBuildInputs = [
    xz
    pugixml
    zlib
  ];
  propagatedBuildInputs = [
    inputstream-adaptive
    inputstream-ffmpegdirect
    inputstream-rtmp
  ];

  meta = with lib; {
    homepage = "https://github.com/kodi-pvr/pvr.iptvsimple";
    description = "Kodi's IPTV Simple client addon";
    platforms = platforms.all;
    license = licenses.gpl2Plus;
    maintainers = teams.kodi.members;
  };
}
