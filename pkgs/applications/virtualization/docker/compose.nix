{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "docker-compose";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "compose";
    rev = "v${version}";
    sha256 = "sha256-2wNC3APKbJ3Ug8M3w4nllfWlKTd10W7W/Csq/3xbXAI=";
  };

  vendorSha256 = "sha256-RzAQnuOjT8eMH+rJm+/JrF96PZbCgzDVNPQYUeXPWnY=";

  ldflags = ["-X github.com/docker/compose/v2/internal.Version=${version}"];

  doCheck = false;
  installPhase = ''
    install -D $GOPATH/bin/cmd $out/libexec/docker/cli-plugins/docker-compose
  '';

  meta = with lib; {
    description = "Docker CLI plugin to define and run multi-container applications with Docker";
    license = licenses.asl20;
    maintainers = [ maintainers.babariviere ];
  };
}
