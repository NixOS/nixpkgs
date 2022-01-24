{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "docker-buildx";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "buildx";
    rev = "v${version}";
    sha256 = "sha256-5EV0Rw1+ufxQ1wmQ0EJXQ7HVtXVbB4do/tet0QFRi08=";
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
