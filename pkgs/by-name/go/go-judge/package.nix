{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "go-judge";
  version = "1.11.3";

  src = fetchFromGitHub {
    owner = "criyle";
    repo = "go-judge";
    rev = "v${version}";
    hash = "sha256-+NqBAxes9xnuyTN0ITrEDlRC8EvgUGBulF3EQx5XSDQ=";
  };

  vendorHash = "sha256-2yuWsNa4jyJEFAox0KMfTYAnwVv622hHErEd2RtJgl4=";

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
