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

stdenv.mkDerivation (finalAttrs: {
  pname = "jwm-settings-manager";
  version = "2019-01-27";

  src = fetchbzr {
    url = "lp:jwm-settings-manager";
    rev = "292";
    hash = "sha256-sVIwFymOXfVMr4XBHHzJtD0vg34Kh3s+QmyuK5gKDPs=";
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
})
