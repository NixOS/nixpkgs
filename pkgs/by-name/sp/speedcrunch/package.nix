{
  stdenv,
  lib,
  fetchFromBitbucket,
  cmake,
  libsForQt5,
}:

stdenv.mkDerivation {
  pname = "speedcrunch";
  version = "0.12-unstable-2024-12-02";

  src = fetchFromBitbucket {
    owner = "heldercorreia";
    repo = "speedcrunch";
    rev = "db51fc5e547aa83834761d874d3518c06d0fec9e";
    hash = "sha256-rnl4z/HU3lAF9Y1JvdM8LZWIV1NGfR4q5gOMxlNU2EA=";
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
