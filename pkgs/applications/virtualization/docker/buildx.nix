{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "docker-buildx";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "buildx";
    rev = "v${version}";
    hash = "sha256-KAOE9nRbEGiqoRYKKu8hZSwXZJvHlcd7Al/Fh+R2LIo=";
  };

  doCheck = false;

  vendorHash = null;

  ldflags = [
    "-w"
    "-s"
    "-X github.com/docker/buildx/version.Package=github.com/docker/buildx"
    "-X github.com/docker/buildx/version.Version=v${version}"
  ];

  installPhase = ''
    runHook preInstall
    install -D $GOPATH/bin/buildx $out/libexec/docker/cli-plugins/docker-buildx

    mkdir -p $out/bin
    ln -s $out/libexec/docker/cli-plugins/docker-buildx $out/bin/docker-buildx
    runHook postInstall
  '';

  meta = {
    description = "Docker CLI plugin for extended build capabilities with BuildKit";
    mainProgram = "docker-buildx";
    homepage = "https://github.com/docker/buildx";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      ivan-babrou
      developer-guy
    ];
  };
}
