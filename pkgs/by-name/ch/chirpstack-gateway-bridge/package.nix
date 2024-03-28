{ lib
, buildGoModule
, fetchFromGitHub
}: buildGoModule rec {
  pname = "chirpstack-gateway-bridge";
  version = "4.0.11";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-gateway-bridge";
    rev = "6897fe56c2b8e631632fe2ed37e4d6dbd903f563";
    hash = "sha256-nVrYyvoN6jayXAwivwxhijNeLEcGICTWJ4T9EBs5uaI=";
  };

  vendorHash = "sha256-PX5Jd8fUFEOOd38NNqbV15jbEIcDQRYGk0l1MhtLiTk=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  doCheck = false;

  meta = with lib; {
    description = "ChirpStack Gateway Bridge abstracts Packet Forwarder protocols into Protobuf or JSON over MQTT";
    homepage = "https://www.chirpstack.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ stv0g ];
    platforms = [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
    mainProgram = "chirpstack-gateway-bridge";
  };
}
