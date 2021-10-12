{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "docker-compose";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "compose";
    rev = "v${version}";
    sha256 = "sha256-6OjA3f6c9s/86UPxy9EqLIc/0ZuW6UhKyQdkM7YoTsU=";
  };

  vendorSha256 = "sha256-6h36TZmo0RvB3YzZRmsrs2Fbl+8zPTuL9LxWkuNgRqw=";

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
