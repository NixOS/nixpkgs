{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "docker-compose";
  version = "2.39.4";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "compose";
    rev = "v${version}";
    hash = "sha256-NDNyXK4E7TkviESHLp8M+OI56ME0Hatoi9eWjX+G1zo=";
  };

  postPatch = ''
    # entirely separate package that breaks the build
    rm -rf pkg/e2e/
  '';

  vendorHash = "sha256-Uqzul9BiXHAJ1BxlOtRS68Tg71SDva6kg3tv7c6ar2E=";

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

  meta = with lib; {
    description = "Docker CLI plugin to define and run multi-container applications with Docker";
    mainProgram = "docker-compose";
    homepage = "https://github.com/docker/compose";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
