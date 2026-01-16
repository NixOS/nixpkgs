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
  renderSystem = if withOgre then "8" else "4";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mygui";
  version = "3.4.3";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "cryham";
    repo = "mygui-next";
    # https://github.com/cryham/mygui-next/tree/ogre3
    rev = "ogre3";
    sha256 = "0yy294l7s5yfn3nk44zdi8rq9j3xkf4paal6iimqp4g6qr72pka7";
  };

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
    libX11
  ];

  # Tools are disabled due to compilation failures.
  cmakeFlags = [
    (lib.cmakeBool "MYGUI_BUILD_DEMOS" false)
    (lib.cmakeBool "MYGUI_BUILD_TOOLS" false)
    (lib.cmakeBool "MYGUI_DONT_USE_OBSOLETE" true)
    (lib.cmakeFeature "MYGUI_RENDERSYSTEM" renderSystem)
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString withOgre "-I${ogre}/include/OGRE -I${ogre}/include/OGRE/Hlms/Common -I${ogre}/include/OGRE/Hlms/Unlit -I${ogre}/include/OGRE/Hlms/Pbs";

  meta = {
    homepage = "http://mygui.info/";
    changelog = "https://github.com/MyGUI/mygui/releases/tag/MyGUI${finalAttrs.version}";
    description = "Library for creating GUIs for games and 3D applications";
    maintainers = with lib.maintainers; [ sigmasquadron ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;

    # error: implicit instantiation of undefined template 'std::char_traits'
    badPlatforms = lib.platforms.darwin;
  };
})
