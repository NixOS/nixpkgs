{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt5,
}:

stdenv.mkDerivation rec {
  pname = "qmqtt";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "emqx";
    repo = "qmqtt";
    rev = "v${version}";
    hash = "sha256-JLGwEF5e/IKzPzCQBzB710REGWbc/MW+r5AHmyYUkUI=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    qt5.qtbase
  ];

  meta = with lib; {
    description = "MQTT client for Qt";
    homepage = "https://github.com/emqx/qmqtt";
    license = licenses.epl10;
    maintainers = with maintainers; [ hexa ];
    platforms = platforms.all;
  };
}
