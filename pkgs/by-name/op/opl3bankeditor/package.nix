{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  cmake,
  pkg-config,
  qt6Packages,
  rtaudio,
  rtmidi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opl3bankeditor";
  version = "1.5.1-unstable-2026-01-03";

  src = fetchFromGitHub {
    owner = "Wohlstand";
    repo = "opl3bankeditor";
    rev = "9d0084cc7073ca911446257c7b937901267c3243";
    fetchSubmodules = true;
    hash = "sha256-wUHpXZ0McL6WLqogXaA+HtVpKxC/Dc5Ji4PnjCksoGE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6Packages.qttools
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    qt6Packages.qtbase
    qt6Packages.qwt
    rtaudio
    rtmidi
  ];

  cmakeFlags = [
    (lib.strings.cmakeFeature "BUILD_MAJOR_QT" "6")
    (lib.strings.cmakeBool "FORCE_EXEC_NO_PIE" false)
    (lib.strings.cmakeBool "USE_RTAUDIO" true)
    (lib.strings.cmakeBool "USE_RTMIDI" true)
    (lib.strings.cmakeBool "USE_VENDORED_RTAUDIO" false)
    (lib.strings.cmakeBool "USE_VENDORED_RTMIDI" false)
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/{bin,Applications}
    mv "OPL3 Bank Editor.app" $out/Applications/

    install_name_tool -change {,${qt6Packages.qwt}/lib/}libqwt.6.dylib "$out/Applications/OPL3 Bank Editor.app/Contents/MacOS/OPL3 Bank Editor"

    ln -s "$out/Applications/OPL3 Bank Editor.app/Contents/MacOS/OPL3 Bank Editor" $out/bin/opl3_bank_editor
  '';

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };

  meta = {
    mainProgram = "opl3_bank_editor";
    description = "Small cross-platform editor of the OPL3 FM banks of different formats";
    homepage = "https://github.com/Wohlstand/opl3bankeditor";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ OPNA2608 ];
  };
})
