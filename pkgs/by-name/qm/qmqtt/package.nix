{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qmqtt";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "emqx";
    repo = "qmqtt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oOXjfkB3e5qeqjqLF4HXeD0K9A0a2UcfdnqZIg3Gn6E=";
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
