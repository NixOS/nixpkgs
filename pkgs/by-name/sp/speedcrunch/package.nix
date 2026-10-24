{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "speedcrunch";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "heldercorreia";
    repo = "speedcrunch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ynDmrdokW9Lvbd+wmwtFxyUP11W0GGV+3l8UMNq+TrU=";
  };

  nativeBuildInputs = [
    cmake
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qttools
  ];

  meta = {
    homepage = "https://speedcrunch.org";
    changelog = "https://github.com/heldercorreia/speedcrunch/releases/tag/v${finalAttrs.version}";
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
})
