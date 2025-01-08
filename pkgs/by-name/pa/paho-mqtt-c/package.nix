{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
  enableStatic ? stdenv.hostPlatform.isStatic,
  enableShared ? !stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation rec {
  pname = "paho.mqtt.c";
  version = "1.3.14";

  src = fetchFromGitHub {
    owner = "eclipse";
    repo = "paho.mqtt.c";
    rev = "v${version}";
    hash = "sha256-42P55qzt3FUp6yQdsP82va0wXg0EWDRGL/KuZpjp04g=";
  };

  postPatch = ''
    substituteInPlace src/MQTTVersion.c \
      --replace "namebuf[60]" "namebuf[120]" \
      --replace "lib%s" "$out/lib/lib%s"
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [ openssl ];

  cmakeFlags = [
    (lib.cmakeBool "PAHO_WITH_SSL" true)
    (lib.cmakeBool "PAHO_BUILD_STATIC" enableStatic)
    (lib.cmakeBool "PAHO_BUILD_SHARED" enableShared)
  ];

  meta = with lib; {
    description = "Eclipse Paho MQTT C Client Library";
    mainProgram = "MQTTVersion";
    homepage = "https://www.eclipse.org/paho/";
    license = licenses.epl20;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
