{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "docker-compose";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "compose";
    tag = "v${version}";
    hash = "sha256-2lyjTNd4jf+wTtnFZaRT10ga0MHZondzb+0cM0ftCuY=";
  };

  vendorHash = "sha256-A9RHSM6BmcaIVHWOou50T1+N/Vh8H1+KtSKeh/ZJ2JQ=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  modPostBuild = ''
    patch -d vendor/github.com/docker/cli/ -p1 < ${./cli-system-plugin-dir-from-env.patch}
  '';

  ldflags = [
    "-X github.com/docker/compose/v5/internal.Version=${version}"
    "-s"
    "-w"
  ];

  doCheck = false;
  doInstallCheck = true;
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
