{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "docker-compose";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "compose";
    rev = "v${version}";
    sha256 = "sha256-dHq1t1ebPSAS5H14Kd03xCiHV9UhAH0dIxikQK0rHQk=";
  };

  vendorSha256 = "sha256-N+paN3zEXzzUFb2JPVIDZYZ0h0iu7naiw4pSVnGsuKQ=";

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
