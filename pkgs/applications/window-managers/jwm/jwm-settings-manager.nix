{
  lib,
  stdenv,
  fetchbzr,
  cmake,
  pkg-config,
  gettext,
  libxpm,
  libGL,
  fltk,
  hicolor-icon-theme,
  glib,
  gnome2,
  which,
}:

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
    libxpm
    libGL
    fltk
    hicolor-icon-theme
    which # needed at runtime to locate optional programs
    glib.bin # provides gsettings
    gnome2.GConf # provides gconftool-2
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8)" "cmake_minimum_required(VERSION 3.10)" \
      --replace-fail 'CMAKE_INSTALL_PREFIX "/usr"' "CMAKE_INSTALL_PREFIX $out"
    substituteInPlace data/CMakeLists.txt \
      --replace-fail 'DESTINATION usr/share' "DESTINATION share"
  '';

  meta = {
    description = "Full configuration manager for JWM";
    homepage = "https://joewing.net/projects/jwm";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.romildo ];
  };
}
