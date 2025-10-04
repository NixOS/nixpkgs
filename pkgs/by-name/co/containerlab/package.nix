{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "containerlab";
  version = "0.70.2";

  src = fetchFromGitHub {
    owner = "srl-labs";
    repo = "containerlab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QBv0SZ7XxVc0yWbOxPKdfzk9AKYlMJyeZwpAx1jbamk=";
  };

  vendorHash = "sha256-XttJ/GXhNKVHLR33A/o3N3OYHsyKWHBhD5QOz0AlfFk=";

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

  # TestVerifyLinks wants to use docker.sock which is not available in the Nix build env
  # KernelModulesLoaded wants to use /proc/modules which is not available in Nix build env
  checkFlags = [
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
    maintainers = with lib.maintainers; [ ];
    mainProgram = "containerlab";
  };
})
