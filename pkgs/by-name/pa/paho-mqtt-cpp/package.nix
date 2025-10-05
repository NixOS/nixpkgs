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
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "eclipse";
    repo = "paho.mqtt.cpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vwfWcJqAWY4Em4MxZVcvOi6pzXAYYlOrKh6peMtjcXo=";
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
