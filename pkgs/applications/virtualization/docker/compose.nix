{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "docker-compose";
  version = "5.5.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "docker";
    repo = "compose";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EUPf76jj4Wc287zZNiDzSljAnwl8adSkUAz8JJaT1es=";
  };

  vendorHash = "sha256-3Jlc/0g/IjH7hhnx70PgZ76Dl8nPzv9M2Gee3TXOGCg=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  modPostBuild = ''
    patch -d vendor/github.com/docker/cli/ -p1 < ${./cli-system-plugin-dir-from-env.patch}
  '';

  ldflags = [
    "-X github.com/docker/compose/v5/internal.Version=${finalAttrs.version}"
    "-s"
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Docker CLI plugin to define and run multi-container applications with Docker";
    mainProgram = "docker-compose";
    homepage = "https://github.com/docker/compose";
    changelog = "https://github.com/docker/compose/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ airone01 ];
  };
})
