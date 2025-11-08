{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  libGL,
  libGLU,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "connectome-workbench";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "Washington-University";
    repo = "workbench";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f1T0i4x7rr3u/3ZvJ4cEAb377e7YcaGMKa2uUslVqR0=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  postPatch = ''
    substituteInPlace kloewe/{cpuinfo,dot}/CMakeLists.txt --replace-fail "cmake_minimum_required(VERSION 3.0)" "cmake_minimum_required(VERSION 3.10)"
  ''
  +
    # tests are minimal and test_driver fails to link (also -DBUILD_TESTING=... is ignored):
    # ld: ../Brain/libBrain.a(BrainOpenGLVolumeObliqueSliceDrawing.cxx.o): undefined reference to symbol 'glGetFloatv'
    # ld: /nix/store/a5vcvrkh1c2ng5kr584g3zw3991vnhks-libGL-1.7.0/lib/libGL.so.1: error adding symbols: DSO missing from command line
    ''
      substituteInPlace CMakeLists.txt  \
        --replace-fail "ADD_SUBDIRECTORY ( Tests )" ""  \
        --replace-fail "ENABLE_TESTING()" ""
    '';

  env.NIX_CFLAGS_COMPILE = "-fpermissive";

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    libGL
    libGLU
  ]
  ++ (with qt6; [
    qtbase
    qt5compat
  ]);
  # note: we should be able to unvendor a few libs (ftgl, quazip, qwt) but they aren't detected properly

  cmakeFlags = [
    "-DWORKBENCH_USE_QT6=TRUE"
    "-DWORKBENCH_USE_QT5=FALSE"
  ];

  meta = {
    description = "Visualization and discovery tool used to map neuroimaging data";
    homepage = "https://www.humanconnectome.org/software/connectome-workbench";
    license = with lib.licenses; [
      gpl2Plus
      gpl3Plus
      mit
    ];
    changelog = "https://github.com/Washington-University/workbench/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ bcdarwin ];
    mainProgram = "wb_command";
    platforms = lib.platforms.linux;
  };
})
