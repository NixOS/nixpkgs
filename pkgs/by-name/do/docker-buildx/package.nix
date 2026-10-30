{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "docker-buildx";
  version = "0.38.1";

  subPackages = [ "cmd/buildx" ];

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "docker";
    repo = "buildx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-prQ+ab+TMK6vZ5Kk9ozBd8Y5/ek1Ia8HgoBWDSYkdPU=";
  };

  vendorHash = null;

  ldflags = [
    "-X github.com/docker/buildx/version.Version=v${finalAttrs.version}"
  ];

  doCheck = false;

  postInstall = ''
    mkdir -p $out/libexec/docker/cli-plugins
    mv $out/bin/buildx $out/libexec/docker/cli-plugins/docker-buildx
    ln -s ../libexec/docker/cli-plugins/docker-buildx $out/bin/docker-buildx
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Docker CLI plugin for extended build capabilities with BuildKit";
    homepage = "https://github.com/docker/buildx";
    changelog = "https://github.com/docker/buildx/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "docker-buildx";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      ivan-babrou
      developer-guy
    ];
  };
})
