{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "docker-compose";
  version = "2.10.1";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "compose";
    rev = "v${version}";
    sha256 = "sha256-SAq6sXhYySqebXbWHJ9X6q1wWnNJjgwKf8YLTXZpKuA=";
  };

  vendorSha256 = "sha256-Yz2lea+ttgNbfP1mL+kwTKmo81Q6GGjJyvDANzeckpo=";

  ldflags = [ "-X github.com/docker/compose/v2/internal.Version=${version}" "-s" "-w" ];

  doCheck = false;
  installPhase = ''
    runHook preInstall
    install -D $GOPATH/bin/cmd $out/libexec/docker/cli-plugins/docker-compose

    mkdir -p $out/bin
    ln -s $out/libexec/docker/cli-plugins/docker-compose $out/bin/docker-compose
    runHook postInstall
  '';

  meta = with lib; {
    description = "Docker CLI plugin to define and run multi-container applications with Docker";
    homepage = "https://github.com/docker/compose";
    license = licenses.asl20;
    maintainers = with maintainers; [ babariviere SuperSandro2000 ];
  };
}
