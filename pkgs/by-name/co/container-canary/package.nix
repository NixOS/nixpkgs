{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "container-canary";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "container-canary";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AipqNkHcC8N6PfSDvSvb9O8L/GuQvA/d4y+NZPZipI4=";
  };

  vendorHash = "sha256-HqSt/LJP9K6LwG9Uf3qqui9LXaOqbCEOL6WzXX5N/VI=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/nvidia/container-canary/internal.Version=${finalAttrs.version}"
    "-X=github.com/nvidia/container-canary/internal.Buildtime=1970-01-01T00:00:00Z"
    "-X=github.com/nvidia/container-canary/internal.Commit=${finalAttrs.src.tag}"
  ];

  checkFlags =
    let
      # Skip tests that require access to container runtime like Docker
      skippedTests = [
        "TestDockerContainer"
        "TestDockerContainerRemoves"
        "TestValidate"
        "TestValidateFails"
        "TestFileDoesNotExist"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall = ''
    mv $out/bin/container-canary $out/bin/canary
  ''
  + (lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd canary \
      --bash <($out/bin/canary completion bash) \
      --zsh <($out/bin/canary completion zsh) \
      --fish <($out/bin/canary completion fish)
  '');

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for testing and validating container requirements against versioned manifests";
    homepage = "https://github.com/NVIDIA/container-canary";
    changelog = "https://github.com/NVIDIA/container-canary/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "canary";
  };
})
