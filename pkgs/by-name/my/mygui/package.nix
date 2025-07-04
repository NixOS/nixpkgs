{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  boost,
  freetype,
  libuuid,
  ois,
  withOgre ? false,
  ogre,
  libGL,
  libGLU,
  libX11,
}:

let
  renderSystem = if withOgre then "3" else "4";
in
stdenv.mkDerivation rec {
  pname = "mygui";
  version = "3.4.3";

  src = fetchFromGitHub {
    owner = "MyGUI";
    repo = "mygui";
    rev = "MyGUI${version}";
    hash = "sha256-qif9trHgtWpYiDVXY3cjRsXypjjjgStX8tSWCnXhXlk=";
  };

  patches = [
    (fetchpatch {
      name = "darwin-mygui-framework-fix.patch";
      url = "https://gitlab.com/OpenMW/openmw-dep/-/raw/ade30e6e98c051ac2a505f6984518f5f41fa87a5/macos/mygui.patch";
      sha256 = "sha256-Tk+O4TFgPZOqWAY4c0Q69bZfvIB34wN9e7h0tXhLULU=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost
    freetype
    libuuid
    ois
  ]
  ++ lib.optionals withOgre [
    ogre
  ]
  ++ lib.optionals (!withOgre && stdenv.hostPlatform.isLinux) [
    libGL
    libGLU
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libX11
  ];

  # Tools are disabled due to compilation failures.
  cmakeFlags = [
    "-DMYGUI_BUILD_TOOLS=OFF"
    "-DMYGUI_BUILD_DEMOS=OFF"
    "-DMYGUI_RENDERSYSTEM=${renderSystem}"
    "-DMYGUI_DONT_USE_OBSOLETE=ON"
  ];

  meta = with lib; {
    homepage = "http://mygui.info/";
    description = "Library for creating GUIs for games and 3D applications";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
