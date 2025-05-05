{
  stdenv,
  lib,
  libsForQt5,
  fetchFromGitHub,
  cmake,
  doxygen,
  msgpack,
  neovim,
  python3Packages,
}:

stdenv.mkDerivation rec {
  pname = "neovim-qt-unwrapped";
  version = "0.2.19";

  src = fetchFromGitHub {
    owner = "equalsraf";
    repo = "neovim-qt";
    rev = "v${version}";
    hash = "sha256-r77tg3xVemHW/zDNA6dYerFjFaYDDeHsD68WhMfI70Q=";
  };

  cmakeFlags = [
    "-DUSE_SYSTEM_MSGPACK=1"
    "-DENABLE_TESTS=0" # tests fail because xcb platform plugin is not found
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs =
    [
      neovim.unwrapped # only used to generate help tags at build time
      libsForQt5.qtbase
      libsForQt5.qtsvg
    ]
    ++ (with python3Packages; [
      jinja2
      python
      msgpack
    ]);

  preCheck = ''
    # The GUI tests require a running X server, disable them
    sed -i ../test/CMakeLists.txt -e '/^add_xtest_gui/d'
  '';

  doCheck = true;

  meta = with lib; {
    description = "Neovim client library and GUI, in Qt5";
    homepage = "https://github.com/equalsraf/neovim-qt";
    license = licenses.isc;
    mainProgram = "nvim-qt";
    maintainers = with maintainers; [ peterhoeg ];
    inherit (neovim.meta) platforms;
  };
}
