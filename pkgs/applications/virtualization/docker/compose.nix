{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "docker-compose";
  version = "2.40.2";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "compose";
    rev = "v${version}";
    hash = "sha256-ErSN1udzwIHX3dpCh4CJAa65u1MxuM4WafpwitjehDE=";
  };

  postPatch = ''
    # entirely separate package that breaks the build
    rm -rf pkg/e2e/
  '';

  vendorHash = "sha256-ArfIY555lUD0T4YfduENRWD1KqtCL6MM1hREXP8VOEA=";

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
