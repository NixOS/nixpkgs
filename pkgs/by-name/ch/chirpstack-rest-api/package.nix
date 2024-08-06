{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitUpdater,
}:
buildGoModule rec {
  pname = "chirpstack-rest-api";
  version = "4.7.0";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-rest-api";
    rev = "v${version}";
    hash = "sha256-6cCwKI9SWXvvgilkG+ZnRUv6XTyMvNnPRGMbOY7jgLw=";
  };

  vendorHash = "sha256-f9AsvVIep5YteD0EJzT0ZXQ6GQNz2doc4bORGg3U+xQ=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  doCheck = false;

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = with lib; {
    description = "ChirpStack gRPC API to REST proxy";
    homepage = "https://www.chirpstack.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ stv0g ];
    mainProgram = "chirpstack-rest-api";
  };
}
