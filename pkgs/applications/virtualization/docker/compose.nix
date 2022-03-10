{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "docker-compose";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "compose";
    rev = "v${version}";
    sha256 = "sha256-DbZzVyTafBVsXvm1/aSdXJruKxBq5Ff8AIfDREFFVh0=";
  };

  vendorSha256 = "sha256-ePL1L/A+48JEu6jpbzy8UBWrFY10iqITILSclfYs8Lw=";

  ldflags = [ "-X github.com/docker/compose/v2/internal.Version=${version}" "-s" "-w" ];

  doCheck = false;
  installPhase = ''
    install -D $GOPATH/bin/cmd $out/libexec/docker/cli-plugins/docker-compose
  '';

  meta = with lib; {
    description = "Docker CLI plugin to define and run multi-container applications with Docker";
    homepage = "https://github.com/docker/compose";
    license = licenses.asl20;
    maintainers = with maintainers; [ babariviere SuperSandro2000 ];
  };
}
