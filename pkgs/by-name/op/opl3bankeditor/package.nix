{
  stdenv,
  lib,
  fetchFromGitHub,
  dos2unix,
  cmake,
  pkg-config,
  libsForQt5,
  rtaudio,
  rtmidi,
}:

stdenv.mkDerivation rec {
  pname = "opl3bankeditor";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "Wohlstand";
    repo = "opl3bankeditor";
    rev = "v${version}";
    sha256 = "08krbxlxgmc7i2r2k6d6wgi0m6k8hh3j60xf21kz4kp023w613sa";
  };

  prePatch = ''
    dos2unix CMakeLists.txt
  '';

  patches = [
    ./0001-opl3bankeditor-Look-for-system-installed-Rt-libs.patch
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
    mv "OPL3 Bank Editor.app" $out/Applications/

    install_name_tool -change {,${libsForQt5.qwt6_1}/lib/}libqwt.6.dylib "$out/Applications/OPL3 Bank Editor.app/Contents/MacOS/OPL3 Bank Editor"

    ln -s "$out/Applications/OPL3 Bank Editor.app/Contents/MacOS/OPL3 Bank Editor" $out/bin/opl3_bank_editor
  '';

  meta = {
    mainProgram = "opl3_bank_editor";
    description = "Small cross-platform editor of the OPL3 FM banks of different formats";
    homepage = src.meta.homepage;
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ OPNA2608 ];
  };
}
