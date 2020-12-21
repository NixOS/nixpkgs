{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "docker-buildx";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "buildx";
    rev = "v${version}";
    sha256 = "0l03ncs1x4lhgy0kf7bd1zq00md8fi93f8xq6k0ans4400divfzk";
  };

  vendorSha256 = null;

  installPhase = ''
    install -D $GOPATH/bin/buildx $out/libexec/docker/cli-plugins/docker-buildx
  '';

  meta = with lib; {
    description = "Docker CLI plugin for extended build capabilities with BuildKit";
    license = licenses.asl20;
    maintainers = [ maintainers.ivan-babrou ];
  };
}
