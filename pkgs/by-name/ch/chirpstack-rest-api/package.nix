{ lib
, buildGoModule
, fetchFromGitHub
}: buildGoModule rec {
  pname = "chirpstack-rest-api";
  version = "4.7.0";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-rest-api";
    rev = "c660a96d7856f14fd9c2b3bdbe1c183f4d7438f9";
    hash = "sha256-6cCwKI9SWXvvgilkG+ZnRUv6XTyMvNnPRGMbOY7jgLw=";
  };

  vendorHash = "sha256-f9AsvVIep5YteD0EJzT0ZXQ6GQNz2doc4bORGg3U+xQ=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  doCheck = false;

  meta = with lib; {
    description = "ChirpStack gRPC API to REST proxy";
    homepage = "https://www.chirpstack.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ stv0g ];
    platforms = [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
    mainProgram = "chirpstack-rest-api";
  };
}
