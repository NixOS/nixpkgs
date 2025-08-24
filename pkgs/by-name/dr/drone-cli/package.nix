{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  version = "1.9.0";
  pname = "drone-cli";
  revision = "v${version}";

  src = fetchFromGitHub {
    owner = "harness";
    repo = "drone-cli";
    rev = revision;
    hash = "sha256-XE0myh+PAl8JhoUhEdjdCe52vQo3NuA8/v/x+v5zHK4=";
  };

  vendorHash = "sha256-22sefx/2iLvVzN+6wJ7kbDFAv10PQNmWbia+HFzmaW8=";

  # patch taken from https://patch-diff.githubusercontent.com/raw/harness/drone-cli/pull/179.patch
  # but with go.mod changes removed due to conflict
  patches = [ ./0001-use-builtin-go-syscerts.patch ];

  ldflags = [
    "-X main.version=${version}"
  ];

  meta = with lib; {
    mainProgram = "drone";
    maintainers = with maintainers; [ techknowlogick ];
    license = licenses.asl20;
    description = "Command line client for the Drone continuous integration server";
  };
}
