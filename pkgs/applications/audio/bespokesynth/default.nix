{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, cairo, libxkbcommon, xcbutilcursor, xcbutilkeysyms, xcbutil, libXrandr, libXinerama, libXcursor, alsa-lib, libjack2 ,lv2, gcc-unwrapped, libusb1, python
}:

stdenv.mkDerivation rec {
  pname = "BespokeSynth";
  version = "unstable-2021-09-29";

  src = fetchFromGitHub {
    owner = "BespokeSynth";
    repo = pname;
    rev = "494514e56dff59bcb0d385264de4af271c092983";
    sha256 = "0wsc0glrkiyf6lq3ypnajsn3l3g2c5s46cjvqx95i3vj2yxrcbbw";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ cairo libxkbcommon xcbutilcursor xcbutilkeysyms xcbutil libXrandr libXinerama libXcursor alsa-lib libjack2 lv2 libusb1 python];

  meta = with lib; {
    description = "Software modular synth";
    homepage = "https://bespokesynth.com";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ magnetophon ];
  };
}
