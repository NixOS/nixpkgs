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
  pname = "opn2bankeditor";
  version = "1.3-unstable-2026-10-22";

  src = fetchFromGitHub {
    owner = "Wohlstand";
    repo = "opn2bankeditor";
    rev = "f0c649c86b91317929def0c2a2b2d4e150bf4bd6";
    fetchSubmodules = true;
    hash = "sha256-bj9iIUa5sh+AhIk3VvDbgx6BVQQNYQJfMorOvAvFUus=";
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
    (lib.strings.cmakeBool "USE_RTAUDIO" true)
    (lib.strings.cmakeBool "USE_RTMIDI" true)
    (lib.strings.cmakeBool "USE_VENDORED_RTAUDIO" false)
    (lib.strings.cmakeBool "USE_VENDORED_RTMIDI" false)
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/{bin,Applications}
    mv "OPN2 Bank Editor.app" $out/Applications/

    install_name_tool -change {,${qt6Packages.qwt}/lib/}libqwt.6.dylib "$out/Applications/OPN2 Bank Editor.app/Contents/MacOS/OPN2 Bank Editor"

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
