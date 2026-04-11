{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  dos2unix,
  cmake,
  pkg-config,
  libsForQt5,
  rtaudio,
  rtmidi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opn2bankeditor";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "Wohlstand";
    repo = "opn2bankeditor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YigxCgGIjOrwDxNgcIwiW8d3qHlDyA7o0vUUb5SpKlo=";
  };

  prePatch = ''
    dos2unix CMakeLists.txt
  '';

  patches = [
    ./0001-opn2bankeditor-Look-for-system-installed-Rt-libs.patch
  ];

  nativeBuildInputs = [
    dos2unix
    cmake
    pkg-config
    libsForQt5.qttools
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qwt6_1
    rtaudio
    rtmidi
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.2)" "cmake_minimum_required(VERSION 3.10)"
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/{bin,Applications}
    mv "OPN2 Bank Editor.app" $out/Applications/

    install_name_tool -change {,${libsForQt5.qwt6_1}/lib/}libqwt.6.dylib "$out/Applications/OPN2 Bank Editor.app/Contents/MacOS/OPN2 Bank Editor"

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
