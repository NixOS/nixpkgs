{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "nats-kafka";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-RboNlKpD+4mOx6iL6JpguR90y6Ux1x0twFcazIPj0w0=";
  };

  vendorHash = "sha256-Zo4lAV/1TIblTbFrZcwvVecvAAgX+8N6OmdeNyI6Ja0=";

  ldflags = [
    "-X github.com/nats-io/nats-kafka/server/core.Version=v${version}"
  ];

  # do not build & install test binaries
  subPackages = [ "." ];

  # needs running nats-server and kafka
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "NATS to Kafka Bridging";
    mainProgram = "nats-kafka";
    homepage = "https://github.com/nats-io/nats-kafka";
    changelog = "https://github.com/nats-io/nats-kafka/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ misuzu ];
  };
}
