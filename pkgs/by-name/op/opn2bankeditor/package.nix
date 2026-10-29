{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  cmake,
  pkg-config,
  # No Qt6 yet: https://github.com/Wohlstand/OPN2BankEditor/issues/126
  libsForQt5,
  rtaudio,
  rtmidi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opn2bankeditor";
  version = "1.3-unstable-2026-01-01";

  src = fetchFromGitHub {
    owner = "Wohlstand";
    repo = "opn2bankeditor";
    rev = "0371db0867ac23f49e8d160f9fd3163cf1fe41a2";
    fetchSubmodules = true;
    hash = "sha256-+BgvzZoGAh9KlKjAyn7BsWnfGDB5njW8tJoFwtY0fCo=";
  };

  # https://github.com/Wohlstand/OPN2BankEditor/issues/125
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'cmake_minimum_required(VERSION 3.2)' 'cmake_minimum_required(VERSION 3.2...3.10)'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.qttools
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qwt
    rtaudio
    rtmidi
  ];

  cmakeFlags = [
    (lib.strings.cmakeBool "USE_RTAUDIO" true)
    (lib.strings.cmakeBool "USE_RTMIDI" true)
    (lib.strings.cmakeBool "USE_VENDORED_RTAUDIO" false)
    (lib.strings.cmakeBool "USE_VENDORED_RTMIDI" false)
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/{bin,Applications}
    mv "OPN2 Bank Editor.app" $out/Applications/

    install_name_tool -change {,${libsForQt5.qwt}/lib/}libqwt.6.dylib "$out/Applications/OPN2 Bank Editor.app/Contents/MacOS/OPN2 Bank Editor"

    ln -s "$out/Applications/OPN2 Bank Editor.app/Contents/MacOS/OPN2 Bank Editor" $out/bin/opn2_bank_editor
  '';

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };

  meta = {
    mainProgram = "opn2_bank_editor";
    description = "Small cross-platform editor of the OPN2 FM banks of different formats";
    homepage = "https://github.com/Wohlstand/opn2bankeditor";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ OPNA2608 ];
  };
})
