{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "go-judge";
  version = "1.9.6";

  src = fetchFromGitHub {
    owner = "criyle";
    repo = "go-judge";
    rev = "v${version}";
    hash = "sha256-hD33oD2JHabeVF5sHhud5czFQUC9gZEb1gri/JUFYK8=";
  };

  vendorHash = "sha256-JmRAFNmmEADVsV0zpctIVRlXc4DYyXX3RrBQW0MP8ow=";

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
