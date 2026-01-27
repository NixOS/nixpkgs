{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "containerlab";
  version = "0.72.0";

  src = fetchFromGitHub {
    owner = "srl-labs";
    repo = "containerlab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NybykyCzOqK7ElyUyKbnDxrQSkwltm0y4OhzVHdm6ok=";
  };

  vendorHash = "sha256-PeabygD6QbL5UhQaQdTn39Ab3uZ54WZ5CIlYpr0rLT0=";

  nativeBuildInputs = [
    installShellFiles
    versionCheckHook
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/srl-labs/containerlab/cmd.Version=${finalAttrs.version}"
    "-X github.com/srl-labs/containerlab/cmd.commit=${finalAttrs.src.rev}"
    "-X github.com/srl-labs/containerlab/cmd.date=1970-01-01T00:00:00Z"
  ];

  preCheck = ''
    # Fix failed TestLabelsInit test
    export USER="runner"
  '';

  checkFlags = [
    # Not available in sandbox:
    # - docker.sock needed for TestVerifyLinks
    # - /proc/modules needed for KernelModulesLoaded
    "-skip=^TestVerifyLinks$|^TestIsKernelModuleLoaded$"
  ];

  postInstall = ''
    local INSTALL="$out/bin/containerlab"
    installShellCompletion --cmd containerlab \
      --bash <($out/bin/containerlab completion bash) \
      --fish <($out/bin/containerlab completion fish) \
      --zsh <($out/bin/containerlab completion zsh)
  '';

  doInstallCheck = true;
  versionCheckProgramArg = "version";

  meta = {
    description = "Container-based networking lab";
    homepage = "https://containerlab.dev/";
    changelog = "https://github.com/srl-labs/containerlab/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ _0x4A6F ];
    mainProgram = "containerlab";
  };
})
