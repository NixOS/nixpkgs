{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "go-judge";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "criyle";
    repo = "go-judge";
    rev = "v${version}";
    hash = "sha256-9D//GOcnME4VW4cYKhJnMNdZOoeXrzz7uEOn8ZfujPY=";
  };

  vendorHash = "sha256-pz/S2YIlPeGEkx+epQlDnFAUQdKET7r5c//Cu70V0Bo=";

  tags = [
    "nomsgpack"
    "grpcnotrace"
  ];

  subPackages = [ "cmd/go-judge" ];

  preBuild = ''
    echo v${version} > ./cmd/go-judge/version/version.txt
  '';

  env.CGO_ENABLED = 0;

  meta = {
    description = "High performance sandbox service based on container technologies";
    homepage = "https://docs.goj.ac";
    license = lib.licenses.mit;
    mainProgram = "go-judge";
    maintainers = with lib.maintainers; [ criyle ];
  };
}
