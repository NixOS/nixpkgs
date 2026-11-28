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

  # Upstream runs macdeployqt and codesign on install to produce a
  # self-contained bundle, and its CPack config overrides the install prefix
  # on macOS; neither is wanted here.
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/CMakeLists.txt \
      --replace-fail 'macdeployqt(''${APPLICATION_NAME}.app ''${APPLICATION_NAME})' "" \
      --replace-fail 'include(SpeedCrunchCPack.cmake)' ""
  '';

  nativeBuildInputs = [
    cmake
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qttools
  ];

  # Upstream defaults to arm64 when this is unset.
  cmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeFeature "CMAKE_OSX_ARCHITECTURES" stdenv.hostPlatform.darwinArch)
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications $out/bin
    mv $out/SpeedCrunch.app $out/Applications/
    ln -s $out/Applications/SpeedCrunch.app/Contents/MacOS/SpeedCrunch $out/bin/speedcrunch
  '';

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
  };
})
