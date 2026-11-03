{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "docker-compose";
  version = "5.7.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "docker";
    repo = "compose";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GMXHVWZaJ/fx/jhe3HOkLaKIRHvjiUvlrq9/FrWde6M=";
  };

  vendorHash = "sha256-FWTZtRToK47uii081j9PeW+Jkjd4kMTL3sU6FNH8OAg=";

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
  excludedPackages = [
    # New module `compose-relay` introduced in this release.
    # Compiling compose-relay is unnecessary for `docker-compose`, hence the exclusion.
    # See [the compose-relay README](https://github.com/docker/compose/blob/524a36d2cf2deaf9eed1c3671d7cb93f07671b48/relay/README.md).
    "relay"
  ];
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
