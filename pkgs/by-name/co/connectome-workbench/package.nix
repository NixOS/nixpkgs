{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  libGL,
  libGLU,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "connectome-workbench";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "Washington-University";
    repo = "workbench";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-M5iverVDhBI/ijbgwfa6gHrthY4wrUi+/2A/443jBqg=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  patches = [
    # remove after next release:
    (fetchpatch {
      name = "fix-missing-includes-in-CZIlib";
      url = "https://github.com/Washington-University/workbench/commit/7ba3345d161d567a4b628ceb02ab4471fc96cb20.diff";
      hash = "sha256-DMrJOr/2Wr4o4Z3AuhWfMZTX8f/kOYWwZQzBUwIrTd8=";
      relative = "src";
    })
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt  \
      --replace-fail "ADD_SUBDIRECTORY ( Tests )" ""  \
      --replace-fail "ENABLE_TESTING()" ""
  '';
  # tests are minimal and test_driver fails to link (also -DBUILD_TESTING=... is ignored):
  # ld: ../Brain/libBrain.a(BrainOpenGLVolumeObliqueSliceDrawing.cxx.o): undefined reference to symbol 'glGetFloatv'
  # ld: /nix/store/a5vcvrkh1c2ng5kr584g3zw3991vnhks-libGL-1.7.0/lib/libGL.so.1: error adding symbols: DSO missing from command line

  env.NIX_CFLAGS_COMPILE = "-fpermissive";

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs =
    [
      libGL
      libGLU
    ]
    ++ (with libsForQt5; [
      qtbase
    ]);
  # note: we should be able to unvendor a few libs (ftgl, quazip, qwt) but they aren't detected properly

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
