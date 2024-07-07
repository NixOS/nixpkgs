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
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "eclipse";
    repo = "paho.mqtt.cpp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XAQSNjO34b2BPzAf7x4a+74UdKFH5lYNMJm4kE16nkA=";
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

  meta = with lib; {
    description = "Eclipse Paho MQTT C++ Client Library";
    homepage = "https://www.eclipse.org/paho/";
    license = licenses.epl10;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
})
