{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "go-judge";
  version = "1.9.9";

  src = fetchFromGitHub {
    owner = "criyle";
    repo = "go-judge";
    rev = "v${version}";
    hash = "sha256-orYfnqtNvTIJLAfjrrRU6WT3wKzQCzYmCNEHC8OBlQo=";
  };

  vendorHash = "sha256-2mCd8ymY9l4A2wAe7+MVCsCqT92qIVHHHfkNJvEMg5k=";

  tags = [
    "nomsgpack"
    "grpcnotrace"
  ];

  subPackages = [ "cmd/go-judge" ];

  preBuild = ''
    echo v${version} > ./cmd/go-judge/version/version.txt
  '';

  env.CGO_ENABLED = 0;

  meta = with lib; {
    description = "High performance sandbox service based on container technologies";
    homepage = "https://docs.goj.ac";
    license = licenses.mit;
    mainProgram = "go-judge";
    maintainers = with maintainers; [ criyle ];
  };
}
