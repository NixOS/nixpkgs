{ stdenv, mkDerivation, fetchFromGitHub
, pkg-config, cmake, alsaLib, libjack2, dbus, qtbase, qttools, qtx11extras
# Enable jack session support
, jackSession ? false
}:

mkDerivation rec {
  version = "0.9.0";
  pname = "qjackctl";

  # some dependencies such as killall have to be installed additionally

  src = fetchFromGitHub {
    owner = "rncbc";
    repo = "qjackctl";
    rev = "${pname}_${stdenv.lib.replaceChars ["."] ["_"] version}";
    sha256 = "044kgwk7pfywad4myza0s2kvfkl21zkqq5wgny7n3c43qlcgs3zr";
  };

  buildInputs = [
    qtbase
    qtx11extras
    qttools
    alsaLib
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

  meta = with stdenv.lib; {
    description = "A Qt application to control the JACK sound server daemon";
    homepage = "https://github.com/rncbc/qjackctl";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
