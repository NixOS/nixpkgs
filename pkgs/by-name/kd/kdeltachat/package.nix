{
  lib,
  fetchFromGitHub,
  fetchFromSourcehut,
  cmake,
  extra-cmake-modules,
  pkg-config,
  libdeltachat,
  libsForQt5,
  rustPlatform,
  stdenv,
}:

let
  libdeltachat' = libdeltachat.overrideAttrs rec {
    version = "1.155.6";
    src = fetchFromGitHub {
      owner = "chatmail";
      repo = "core";
      tag = "v${version}";
      hash = "sha256-d7EmmyLSJjFIZM1j6LP8f4WnXiptNTAqOdJD/oPL02Y=";
    };
    cargoDeps = rustPlatform.fetchCargoVendor {
      pname = "deltachat-core-rust";
      inherit version src;
      hash = "sha256-E01aEzNi06LQntrlA+342a8Nl5API6v7HbdmuKpfajs=";
    };
  };
  inherit (libsForQt5)
    kirigami2
    qtbase
    qtimageformats
    qtmultimedia
    qtwebengine
    wrapQtAppsHook
    ;
in
stdenv.mkDerivation {
  pname = "kdeltachat";
  version = "unstable-2024-01-14";

  src = fetchFromSourcehut {
    owner = "~link2xt";
    repo = "kdeltachat";
    rev = "d61a01c2d6d5bdcc9ca500b466ed42689b2bd5c6";
    hash = "sha256-KmL3ODXPi1c8C5z2ySHg0vA5Vg/dZumDZTbpxkzf7A4=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    kirigami2
    libdeltachat'
    qtimageformats
    qtmultimedia
    qtwebengine
  ];

  # needed for qmlplugindump to work
  QT_PLUGIN_PATH = "${qtbase.bin}/${qtbase.qtPluginPrefix}";
  QML2_IMPORT_PATH = lib.concatMapStringsSep ":" (lib: "${lib}/${qtbase.qtQmlPrefix}") [
    kirigami2
    qtmultimedia
  ];

  meta = with lib; {
    description = "Delta Chat client using Kirigami framework";
    mainProgram = "kdeltachat";
    homepage = "https://git.sr.ht/~link2xt/kdeltachat";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.linux;
  };
}
