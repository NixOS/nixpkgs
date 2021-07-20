{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "docker-buildx";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "buildx";
    rev = "v${version}";
    sha256 = "sha256-5j1+3FlLc0gYDnYvDsAdmILxgjHCU1bTVOytfaF03iU=";
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
