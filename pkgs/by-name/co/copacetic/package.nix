{
  lib,
  stdenv,
  buildGoModule,
  docker,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  oras,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "copacetic";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "project-copacetic";
    repo = "copacetic";
    tag = "v${version}";
    hash = "sha256-kgFT+IK6zCGoGK8L/lwXyiUXCWYG7ElziPs0Q1cq+fw=";
  };

  vendorHash = "sha256-qe2VJHXSYtZJlMd5R2J1NXWcXb8+cbTiDBQeN20fbEE=";

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [
    docker
    oras
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  env.CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/project-copacetic/copacetic/pkg/version.GitVersion=${version}"
    "-X=main.version=${version}"
  ];

  checkFlags =
    let
      # Skip tests that require network access and container services
      skippedTests = [
        "TestNewClient/custom_buildkit_addr"
        "TestPatch"
        "TestPlugins/docker.io"
        "TestPatchPartialArchitectures"
        "TestPushToRegistry"
        "TestMultiPlatformPluginPatch"
        "TestPodmanLoader_Load_Success"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  doInstallCheck = true;

  versionCheckProgram = "${placeholder "out"}/bin/${meta.mainProgram}";

  postInstall = ''
    mv $out/bin/copacetic $out/bin/copa
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd copa \
      --bash <($out/bin/copa completion bash) \
      --fish <($out/bin/copa completion fish) \
      --zsh <($out/bin/copa completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for directly patching vulnerabilities in container images";
    homepage = "https://project-copacetic.github.io/copacetic/";
    changelog = "https://github.com/project-copacetic/copacetic/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    mainProgram = "copa";
    maintainers = with lib.maintainers; [ ];
  };
}
