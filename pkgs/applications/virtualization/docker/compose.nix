{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "docker-compose";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "compose";
    tag = "v${version}";
    hash = "sha256-7g9l9SBxPY3jMS3DWZNI/fhOZN1oZo1qkUfhMfbzAaM=";
  };

  vendorHash = "sha256-COfB0MLBMOfTdLbpShBkMOEule/1cu6Bo5lm1ieO/nA=";

  ldflags = [
    "-X github.com/docker/compose/v2/internal.Version=${version}"
    "-s"
    "-w"
  ];

  doCheck = false;
  installPhase = ''
    runHook preInstall
    install -D $GOPATH/bin/cmd $out/libexec/docker/cli-plugins/docker-compose

    mkdir -p $out/bin
    ln -s $out/libexec/docker/cli-plugins/docker-compose $out/bin/docker-compose
    runHook postInstall
  '';

  meta = {
    description = "Docker CLI plugin to define and run multi-container applications with Docker";
    mainProgram = "docker-compose";
    homepage = "https://github.com/docker/compose";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
