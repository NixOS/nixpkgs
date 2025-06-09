{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "go-judge";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "criyle";
    repo = "go-judge";
    rev = "v${version}";
    hash = "sha256-26Fx3bPhAM/Clb5vkU5ml++W0uYT8dnDNabP5Ir1Lx4=";
  };

  vendorHash = "sha256-vkPuGoEBU8FPCW6/10HJZYtI2FzjydsWwv9wy8DXwA8=";

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
