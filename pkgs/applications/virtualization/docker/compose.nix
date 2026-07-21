{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:
buildGoModule rec {
  pname = "docker-compose";
  version = "5.3.1";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "compose";
    tag = "v${version}";
    hash = "sha256-UNORlxZ/b4Jrp9v8pbsxTt8PrYq1/u4AjBU8+pfuG1k=";
  };

  vendorHash = "sha256-Ug6/hpuHgJ2CAUX87/+Tt3cHm4AbJF9oznx61kTVKI4=";

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
    maintainers = with lib.maintainers; [ airone01 ];
  };
}
