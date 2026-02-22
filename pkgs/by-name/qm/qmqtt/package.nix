{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qmqtt";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "emqx";
    repo = "qmqtt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cIzBnJdMFY25cWf1rBoRQx1G0/5S32igF8vcte+nyHI=";
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
