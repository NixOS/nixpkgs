{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "containerlab";
  version = "0.69.2";

  src = fetchFromGitHub {
    owner = "srl-labs";
    repo = "containerlab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wB51Q7spVe4H6ANIt+ug7s2r3sqFLTRsdMH3bgPNCKg=";
  };

  vendorHash = "sha256-28Q1R6P2rpER5RxagnsKy9W3b4FUeRRbkPPovzag//U=";

  nativeBuildInputs = [
    installShellFiles
    versionCheckHook
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/srl-labs/containerlab/cmd/version.Version=${finalAttrs.version}"
    "-X github.com/srl-labs/containerlab/cmd/version.commit=${finalAttrs.src.rev}"
    "-X github.com/srl-labs/containerlab/cmd/version.date=1970-01-01T00:00:00Z"
  ];

  preCheck = ''
    # Fix failed TestLabelsInit test
    export USER="runner"
  '';

  # TestVerifyLinks wants to use docker.sock, which is not available in the Nix build environment.
  checkFlags = [
    "-skip=^TestVerifyLinks$"
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
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "containerlab";
  };
})
