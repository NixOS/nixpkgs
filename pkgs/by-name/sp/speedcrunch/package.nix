{
  stdenv,
  lib,
  fetchFromBitbucket,
  cmake,
  libsForQt5,
}:

stdenv.mkDerivation {
  pname = "speedcrunch";
  version = "unstable-2021-10-09";

  src = fetchFromBitbucket {
    owner = "heldercorreia";
    repo = "speedcrunch";
    rev = "74756f3438149c01e9edc3259b0f411fa319a22f";
    sha256 = "sha256-XxQv+A5SfYXFIRK7yacxGHHne1Q93pwCGeHhchIKizU=";
  };

  sourceRoot = "source/src";

  buildInputs = with libsForQt5; [
    qtbase
    qttools
  ];

  nativeBuildInputs = [
    cmake
  ]
  ++ [
    libsForQt5.wrapQtAppsHook
  ];

  meta = with lib; {
    homepage = "https://speedcrunch.org";
    license = licenses.gpl2Plus;
    description = "Fast power user calculator";
    mainProgram = "speedcrunch";
    longDescription = ''
      SpeedCrunch is a fast, high precision and powerful desktop calculator.
      Among its distinctive features are a scrollable display, up to 50 decimal
      precisions, unlimited variable storage, intelligent automatic completion
      full keyboard-friendly and more than 15 built-in math function.
    '';
    maintainers = with maintainers; [
      j0hax
    ];
    inherit (libsForQt5.qtbase.meta) platforms;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
