{
  stdenv,
  lib,
  qt6,
  fetchFromGitHub,
  cmake,
  doxygen,
  msgpack-c,
  neovim,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "neovim-qt-unwrapped";
  version = "0.2.19";

  src = fetchFromGitHub {
    owner = "equalsraf";
    repo = "neovim-qt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r77tg3xVemHW/zDNA6dYerFjFaYDDeHsD68WhMfI70Q=";
  };

  cmakeFlags = [
    "-DUSE_SYSTEM_MSGPACK=1"
    "-DENABLE_TESTS=0" # tests fail because xcb platform plugin is not found
    "-DWITH_QT=Qt6"
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    qt6.wrapQtAppsHook
    (python3.withPackages (ps: [
      ps.jinja2
      ps.msgpack
    ]))
  ];

  buildInputs = [
    neovim.unwrapped # only used to generate help tags at build time
    qt6.qtbase
    qt6.qtsvg
    msgpack-c
  ];

  preCheck = ''
    # The GUI tests require a running X server, disable them
    sed -i ../test/CMakeLists.txt -e '/^add_xtest_gui/d'
  '';

  doCheck = true;

  meta = {
    description = "Neovim client library and GUI, in Qt5";
    homepage = "https://github.com/equalsraf/neovim-qt";
    license = lib.licenses.isc;
    mainProgram = "nvim-qt";
    maintainers = with lib.maintainers; [
      peterhoeg
    ];
    inherit (neovim.meta) platforms;
  };
})
