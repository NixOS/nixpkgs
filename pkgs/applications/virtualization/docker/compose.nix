{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "docker-compose";
  version = "5.6.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "docker";
    repo = "compose";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ytWNGOs7tWDEFXBU0OuldyCHM0Qr+1PKbYc9hYe9w10=";
  };

  vendorHash = "sha256-NCHNe+aLNsJNtKdgQxyL6cMuu9XxA5ycleHf9gToEks=";

  nativeInstallCheckInputs = [versionCheckHook];

  modPostBuild = ''
    patch -d vendor/github.com/docker/cli/ -p1 < ${./cli-system-plugin-dir-from-env.patch}
  '';

  ldflags = [
    "-X github.com/docker/compose/v5/internal.Version=${finalAttrs.version}"
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
    maintainers = with lib.maintainers; [airone01];
  };
})
