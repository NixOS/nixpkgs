{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "docker-buildx";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "buildx";
    rev = "v${version}";
    sha256 = "sha256-AGRdmYKd76k5tmBTTqsSHj3yOU8QSd11G5ito0O/dWY=";
  };

  vendorSha256 = null;

  ldflags = [
    "-w" "-s"
    "-X github.com/docker/buildx/version.Package=github.com/docker/buildx"
    "-X github.com/docker/buildx/version.Version=v${version}"
  ];

  installPhase = ''
    install -D $GOPATH/bin/buildx $out/libexec/docker/cli-plugins/docker-buildx
  '';

  meta = with lib; {
    description = "Docker CLI plugin for extended build capabilities with BuildKit";
    license = licenses.asl20;
    maintainers = [ maintainers.ivan-babrou ];
  };
}
