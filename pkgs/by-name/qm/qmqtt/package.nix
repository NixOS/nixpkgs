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

  meta = {
    description = "MQTT client for Qt";
    homepage = "https://github.com/emqx/qmqtt";
    license = lib.licenses.epl10;
    maintainers = with lib.maintainers; [ hexa ];
    platforms = lib.platforms.all;
  };
}
