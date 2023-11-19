{ fetchFromGitHub
, qtbase
, stdenv
, lib
, wrapQtAppsHook
, qmake
, qtcharts
, qtwebengine
, qtserialport
, qtwebchannel
, hamlib
, qtkeychain
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "qlog";
  version = "0.29.2";

  src = fetchFromGitHub {
    owner = "foldynl";
    repo = "QLog";
    rev = "v${version}";
    hash = "sha256-g7WgFQPMOaD+3YllZqpykslmPYT/jNVK7/1xaPdbti4=";
    fetchSubmodules = true;
  };

  env.NIX_LDFLAGS = "-lhamlib";

  buildInputs = [
    qtbase
    qtcharts
    qtwebengine
    qtserialport
    qtwebchannel
    hamlib
    qtkeychain
  ];

  nativeBuildInputs = [
    wrapQtAppsHook
    qmake
    pkg-config
  ];

  meta = with lib; {
    description = "Amateur radio logbook software";
    license = with licenses; [ gpl3Only ];
    homepage = "https://github.com/foldynl/QLog";
    maintainers = with maintainers; [ mkg20001 ];
    platforms = with platforms; unix;
  };
}
