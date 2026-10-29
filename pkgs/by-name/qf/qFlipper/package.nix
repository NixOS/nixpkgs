{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  zlib,
  libusb1,
  libGL,
  wrapGAppsHook3,

  libsForQt5,
  nix-update-script,
}:
let
  pname = "qFlipper";
  version = "1.3.3";
  hash = "sha256-/Xzy+OA0Nl/UlSkOOZW2YsOHdJvS/7X3Z3ITkPByAOc=";
  timestamp = "99999999999";
  commit = "nix-${version}";

in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "flipperdevices";
    repo = "qFlipper";
    rev = version;
    fetchSubmodules = true;
    inherit hash;
  };

  nativeBuildInputs = [
    pkg-config
    libsForQt5.qmake
    libsForQt5.qttools
    wrapGAppsHook3
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    zlib
    libusb1
    libGL

    libsForQt5.qtbase
    libsForQt5.qt3d
    libsForQt5.qtsvg
    libsForQt5.qtserialport
    libsForQt5.qtdeclarative
    libsForQt5.qtquickcontrols
    libsForQt5.qtquickcontrols2
    libsForQt5.qtgraphicaleffects
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux) [
    libsForQt5.qtwayland
  ];

  qmakeFlags = [
    "DEFINES+=DISABLE_APPLICATION_UPDATES"
    "CONFIG+=qtquickcompiler"
  ];

  dontWrapGApps = true;

  postPatch = ''
    substituteInPlace qflipper_common.pri \
        --replace 'GIT_VERSION = unknown' 'GIT_VERSION = "${version}"' \
        --replace 'GIT_TIMESTAMP = 0' 'GIT_TIMESTAMP = ${timestamp}' \
        --replace 'GIT_COMMIT = unknown' 'GIT_COMMIT = "${commit}"'
    cat qflipper_common.pri
  '';

  postInstall = ''
    mkdir -p $out/bin
    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      cp qFlipper.app/Contents/MacOS/qFlipper $out/bin
    ''}
    cp qFlipper-cli $out/bin

    mkdir -p $out/etc/udev/rules.d
    cp installer-assets/udev/42-flipperzero.rules $out/etc/udev/rules.d/
  '';

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Cross-platform desktop tool to manage your flipper device";
    homepage = "https://flipperzero.one/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ cab404 ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
    ]; # qtbase doesn't build yet on aarch64-darwin
  };
}
