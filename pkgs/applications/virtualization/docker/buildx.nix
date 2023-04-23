{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "docker-buildx";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "buildx";
    rev = "v${version}";
    sha256 = "sha256-hYEFboZa6RGiy0wr7NEWaf5KCz/O7KGXTc6c9hMmoXk=";
  };

  doCheck = false;

  vendorSha256 = null;

  ldflags = [
    "-w" "-s"
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

  meta = with lib; {
    description = "Docker CLI plugin for extended build capabilities with BuildKit";
    homepage = "https://github.com/docker/buildx";
    license = licenses.asl20;
    maintainers = with maintainers; [ ivan-babrou developer-guy ];
  };
}
