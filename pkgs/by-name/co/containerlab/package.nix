{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "containerlab";
  version = "0.74.0";

  src = fetchFromGitHub {
    owner = "srl-labs";
    repo = "containerlab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8hpLUWEMmEinIhjzjvPa8lU+GsjtZGTg36bZWujgnp4=";
  };

  vendorHash = "sha256-hw7Dln+ur2fBA1InMvJ0J86nGM+ts0DW4ZjU11h7Wyw=";

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
