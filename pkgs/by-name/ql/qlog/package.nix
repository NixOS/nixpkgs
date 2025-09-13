{
  fetchFromGitHub,
  stdenv,
  lib,
  cups,
  hamlib,
  pkg-config,
  qt6,
  qt6Packages,
}:

stdenv.mkDerivation rec {
  pname = "qlog";
  version = "0.46.0";

  src = fetchFromGitHub {
    owner = "foldynl";
    repo = "QLog";
    tag = "v${version}";
    hash = "sha256-yb2wSd3Hu6p/BacXxVekTrwy36FsxHapuRigHBRu1yU=";
    fetchSubmodules = true;
  };

  env.NIX_LDFLAGS = "-lhamlib";

  buildInputs = [
    hamlib
    qt6.qtbase
    qt6.qtcharts
    qt6.qtserialport
    qt6.qtwebchannel
    qt6.qtwebengine
    qt6Packages.qtkeychain
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cups
  ];

  nativeBuildInputs = [
    pkg-config
    qt6.qmake
    qt6.wrapQtAppsHook
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv $out/{qlog.app,Applications}
    ln -s $out/Applications/qlog.app/Contents/MacOS/qlog $out/bin/qlog
  '';

  meta = {
    description = "Amateur radio logbook software";
    mainProgram = "qlog";
    license = with lib.licenses; [ gpl3Only ];
    homepage = "https://github.com/foldynl/QLog";
    maintainers = with lib.maintainers; [
      oliver-koss
    ];
    platforms = with lib.platforms; unix;
  };
}
