{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
  paho-mqtt-c,
  enableStatic ? stdenv.hostPlatform.isStatic,
  enableShared ? !stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "paho.mqtt.cpp";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "eclipse";
    repo = "paho.mqtt.cpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LJ2V+TIVKCNftBk4fK0rCsuNudYg9dSYw/MAL+/raz0=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    openssl
    paho-mqtt-c
  ];

  cmakeFlags = [
    (lib.cmakeBool "PAHO_WITH_SSL" true)
    (lib.cmakeBool "PAHO_BUILD_STATIC" enableStatic)
    (lib.cmakeBool "PAHO_BUILD_SHARED" enableShared)
  ];

  meta = {
    description = "Eclipse Paho MQTT C++ Client Library";
    homepage = "https://www.eclipse.org/paho/";
    license = lib.licenses.epl10;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
})
