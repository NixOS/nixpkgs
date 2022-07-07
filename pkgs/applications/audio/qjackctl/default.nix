{ lib, mkDerivation, fetchFromGitHub
, pkg-config, cmake, alsa-lib, libjack2, dbus, qtbase, qttools, qtx11extras
# Enable jack session support
, jackSession ? false
}:

mkDerivation rec {
  version = "0.9.6";
  pname = "qjackctl";

  # some dependencies such as killall have to be installed additionally

  src = fetchFromGitHub {
    owner = "rncbc";
    repo = "qjackctl";
    rev = "${pname}_${lib.replaceChars ["."] ["_"] version}";
    sha256 = "sha256-8oVnUe+/y4p1WeHMEhKMIl0/ax3PT0pN4f1UJaBmZBw=";
  };

  buildInputs = [
    qtbase
    qtx11extras
    qttools
    alsa-lib
    libjack2
    dbus
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    "-DCONFIG_JACK_VERSION=1"
    "-DCONFIG_JACK_SESSION=${toString jackSession}"
  ];

  meta = with lib; {
    description = "A Qt application to control the JACK sound server daemon";
    homepage = "https://github.com/rncbc/qjackctl";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
