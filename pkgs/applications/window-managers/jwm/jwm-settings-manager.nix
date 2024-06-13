{ lib, stdenv, fetchbzr, cmake, pkg-config, gettext, libXpm, libGL, fltk, hicolor-icon-theme, glib, gnome2, which }:

stdenv.mkDerivation rec {
  pname = "jwm-settings-manager";
  version = "2019-01-27";

  src = fetchbzr {
    url = "lp:${pname}";
    rev = "292";
    sha256 = "1yqc1ac2pbkc88z7p1qags1jygdlr5y1rhc5mx6gapcf54bk0lmi";
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

  postConfigure = ''
    substituteInPlace cmake_install.cmake \
      --replace "/var/empty" "/usr"
  '';

  meta = with lib; {
    description = "Full configuration manager for JWM";
    homepage = "https://joewing.net/projects/jwm";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
