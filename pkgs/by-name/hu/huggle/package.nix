{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  ncurses,
  which,
  cmake,
  qt6,
  yaml-cpp,
  libirc,
}:

stdenv.mkDerivation rec {
  pname = "huggle";
  version = "3.4.14";

  src = fetchFromGitHub {
    owner = "huggle";
    repo = "huggle3-qt-lx";
    rev = version;
    hash = "sha256-obArs5NqjHbuWv+zNGAuulHQz6MUIejRqNvg2l5eZxc=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    pkg-config
    which
    cmake
  ];
  buildInputs = [
    ncurses
    yaml-cpp
    qt6.qtmultimedia
    qt6.qtwebengine
    libirc
  ];

  patches = [
    ./00-remove-third-party.patch
    ./01-extensions.patch
  ];
  postPatch = ''
    rm -r src/3rd
    echo ${version} > src/huggle_core/version.txt
    substituteInPlace src/huggle_core/definitions_prod.hpp --subst-var out
    substituteInPlace src/CMakeLists.txt --replace '@libirc_includes@' '${libirc.out}'
  '';

  cmakeBuildType = "None";

  cmakeFlags = [
    "-S"
    "/build/source/src"
    "-DINSTALL_DATA_DIR=bin"
    "-DQT6_BUILD=ON"
    "-DWEB_ENGINE=ON"
    "-DBUILD_SHARED_LIBS=OFF"
    "-Wno-dev"
    "-DHUGGLE_EXT=TRUE"
  ];

  installTargets = [ "install" ];

  meta = {
    description = "Anti-vandalism tool for use on MediaWiki-based projects";
    mainProgram = "huggle";
    homepage = "https://github.com/huggle/huggle3-qt-lx";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.fee1-dead ];
    platforms = lib.platforms.x86_64;
  };
}
