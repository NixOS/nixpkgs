{
  stdenv,
  lib,
  fetchFromBitbucket,
  cmake,
  qt6,
}:

stdenv.mkDerivation {
  pname = "speedcrunch";
  version = "0.12-unstable-2024-12-02";

  src = fetchFromBitbucket {
    owner = "heldercorreia";
    repo = "speedcrunch";
    rev = "3c1b4c18ccb275eb2891f9d8ff36a9205c0f566b";
    hash = "sha256-9/id5h+5aBntlcsEUGkyEzMJf7we7hMslnkqKDcbaNY=";
  };

  sourceRoot = "source/src";

  patches = [
    ./01-fix-qt6-build.patch
  ];

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qttools
  ];

  meta = {
    homepage = "https://speedcrunch.org";
    license = lib.licenses.gpl2Plus;
    description = "High-precision scientific calculator";
    mainProgram = "speedcrunch";
    longDescription = ''
      SpeedCrunch is a high-precision scientific calculator.
      Among its distinctive features are a syntax-highlighted scrollable display,
      up to 50 decimal places of precision, complex number support, various
      numeric bases, unit conversions, intelligent automatic completion of functions
      and variables, integrated formula book, over 150 built-in scientific constants,
      fully keyboard-driven interface, over 80 built-in mathematical functions and
      support for user-defined functions.
    '';
    maintainers = with lib.maintainers; [
      j0hax
    ];
    inherit (qt6.qtbase.meta) platforms;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
