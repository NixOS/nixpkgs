{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  ninja,
  boost,
  freetype,
  libuuid,
  ois,
  ogre-next,
  libX11,
}:
stdenv.mkDerivation {
  pname = "mygui";
  version = "0-unstable-2024-02-01";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "cryham";
    repo = "mygui-next";
    rev = "a1490ffe01d503c31a00d8277007ffcb27a4258e";
    hash = "sha256-R80rTsbmkYtrjIYqdYmbfciEM4rtEzLtsM4XfShJwns=";
  };

  patches = [ ./mygui-use-pkg-config-for-ogre-next.patch ];

  nativeBuildInputs = [
    cmake
    pkg-config
    ninja
  ];

  buildInputs = [
    boost
    freetype
    libuuid
    ois
    ogre-next
    libX11
  ];

  cmakeFlags = [
    (lib.cmakeBool "MYGUI_BUILD_DEMOS" false)
    (lib.cmakeBool "MYGUI_BUILD_TOOLS" false)
    (lib.cmakeBool "MYGUI_DONT_USE_OBSOLETE" true)
    (lib.cmakeFeature "MYGUI_RENDERSYSTEM" "8")
  ];
}
