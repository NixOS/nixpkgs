{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,

  SDL2,
  boost,
  bullet,
  cmake,
  collada-dom,
  ffmpeg,
  libXt,
  lua,
  luajit,
  lz4,
  mygui,
  openal,
  openscenegraph,
  pkg-config,
  qt6Packages,
  recastnavigation,
  unshield,
  yaml-cpp,

  GLPreference ? "GLVND",
}:
let
  inherit (stdenv.hostPlatform) isDarwin isLinux isAarch64;
  isAarch64Linux = isLinux && isAarch64;
in
assert lib.assertOneOf "GLPreference" GLPreference [
  "GLVND"
  "LEGACY"
];
stdenv.mkDerivation (finalAttrs: {
  pname = "openmw";
  version = "0.50.0";

  __structuredAttrs = true;
  strictDeps = true;

  osg' = (openscenegraph.override { colladaSupport = true; }).overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or [ ]) ++ [
      (fetchpatch {
        # Darwin: Without this patch, OSG won't build osgdb_png.so, which is required by OpenMW.
        name = "darwin-osg-plugins-fix.patch";
        url = "https://gitlab.com/OpenMW/openmw-dep/-/raw/1305497c009dc0e7a6a70fe14f0a2f92b96cbcb4/macos/osg.patch";
        hash = "sha256-G8Y+fnR6FRGxECWrei/Ixch3A3PkRfH6b5q9iawsSCY=";
      })
    ];
    cmakeFlags =
      (oldAttrs.cmakeFlags or [ ])
      ++ [
        "-Wno-dev"
        (lib.cmakeFeature "OpenGL_GL_PREFERENCE" GLPreference)
        (lib.cmakeBool "BUILD_OSG_PLUGINS_BY_DEFAULT" false)
        (lib.cmakeBool "BUILD_OSG_DEPRECATED_SERIALIZERS" false)
      ]
      ++ (map (plugin: lib.cmakeBool "BUILD_OSG_PLUGIN_${plugin}" true) [
        "BMP"
        "DAE"
        "DDS"
        "FREETYPE"
        "JPEG"
        "OSG"
        "PNG"
        "TGA"
      ]);
  });

  bullet' = bullet.overrideAttrs (oldAttrs: {
    cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
      "-Wno-dev"
      (lib.cmakeFeature "OpenGL_GL_PREFERENCE" GLPreference)
      (lib.cmakeBool "USE_DOUBLE_PRECISION" true)
      (lib.cmakeBool "BULLET2_MULTITHREADING" true)
    ];
  });

  src = fetchFromGitLab {
    owner = "OpenMW";
    repo = "openmw";
    tag = "openmw-${finalAttrs.version}";
    hash = "sha256-mPwNyKKqPSZJtcIyx3IhLe3iHOpx6p4+l1wJZqyDMqg=";
  };

  postPatch = ''
    sed '1i#include <memory>' -i components/myguiplatform/myguidatamanager.cpp # gcc12
  ''
  # Don't fix Darwin app bundle
  + lib.optionalString isDarwin ''
    sed -i '/fixup_bundle/d' CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ (with qt6Packages; [
    wrapQtAppsHook
  ]);

  # If not set, OSG plugin .so files become shell scripts on Darwin.
  dontWrapQtApps = isDarwin;

  buildInputs = [
    SDL2
    boost
    collada-dom
    ffmpeg
    libXt
    (if isAarch64Linux then lua else luajit)
    lz4
    mygui
    openal
    recastnavigation
    unshield
    yaml-cpp
  ]
  ++ (with qt6Packages; [
    qttools
  ])
  ++ (with finalAttrs; [
    bullet'
    osg'
  ]);

  cmakeFlags = [
    (lib.cmakeFeature "OpenGL_GL_PREFERENCE" GLPreference)
    (lib.cmakeBool "USE_LUAJIT" (!isAarch64Linux))
    (lib.cmakeBool "OPENMW_USE_SYSTEM_RECASTNAVIGATION" true)
    (lib.cmakeBool "OPENMW_OSX_DEPLOYMENT" isDarwin)
  ];

  meta = {
    description = "Unofficial open source engine reimplementation of the game Morrowind";
    changelog = "https://gitlab.com/OpenMW/openmw/-/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    homepage = "https://openmw.org";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      marius851000
      sigmasquadron
    ];
    platforms = with lib.platforms; linux ++ darwin ++ windows;
    # Nixpkgs' NT infrastructure is currently incapable of building this.
    badPlatforms = lib.platforms.windows;
  };
})
