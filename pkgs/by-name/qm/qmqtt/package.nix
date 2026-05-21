{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qmqtt";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "emqx";
    repo = "qmqtt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OhRvVOJt5GRwNNKsXLpneDyx8SIptP6KAlIAsWOOcjo=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
  ];

  meta = {
    description = "MQTT client for Qt";
    homepage = "https://github.com/emqx/qmqtt";
    license = lib.licenses.epl10;
    maintainers = with lib.maintainers; [ hexa ];
    platforms = lib.platforms.all;
  };
})
