{ lib, stdenv, fetchFromGitHub, pkg-config, cairo, libX11, lv2 }:

stdenv.mkDerivation rec {
  pname = "bchoppr";
<<<<<<< HEAD
  version = "1.12.6";
=======
  version = "1.12.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-/aLoLUpWu66VKd9lwjli+FZZctblrZUPSEsdYH85HwQ=";
    fetchSubmodules = true;
=======
    sha256 = "sha256-P6sbxhgnlek1IJ4i9yTe/3g/2C8oLPKXI3zbLdswvl8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ cairo libX11 lv2 ];

  installFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/sjaehn/BChoppr";
    description = "An audio stream chopping LV2 plugin";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}
