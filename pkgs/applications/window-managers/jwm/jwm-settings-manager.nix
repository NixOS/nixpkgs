{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, gettext, libXpm, libGL, fltk, hicolor-icon-theme, glib, gnome2, which }:

stdenv.mkDerivation {
  pname = "jwm-settings-manager";
  version = "2018-10-19";

  src = fetchFromGitHub {
    owner = "Israel-D";
    repo = "jwm-settings-manager";
    rev = "cb32a70563cf1f3927339093481542b85ec3c8c8";
    sha256 = "0d5bqf74p8zg8azns44g46q973blhmp715k8kcd73x88g7sfir8s";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    gettext
  ];

  buildInputs = [
    libXpm
    libGL
    fltk
    hicolor-icon-theme
    which # needed at runtime to locate optional programs
    glib.bin # provides gsettings
    gnome2.GConf # provides gconftool-2
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace 'CMAKE_INSTALL_PREFIX "/usr"' "CMAKE_INSTALL_PREFIX $out"
    substituteInPlace data/CMakeLists.txt \
      --replace 'DESTINATION usr/share' "DESTINATION share"
  '';

  meta = with lib; {
    description = "A full configuration manager for JWM";
    homepage = "https://joewing.net/projects/jwm";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
