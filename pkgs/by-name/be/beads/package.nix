{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "beads";
  version = "0.27.2";

  src = fetchFromGitHub {
    owner = "steveyegge";
    repo = "beads";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PpuyQCQocmOqt4EYDsjx1nh0dRxt2e7Vu1/KQ74B88Q=";
  };

  vendorHash = "sha256-5p4bHTBB6X30FosIn6rkMDJoap8tOvB7bLmVKsy09D8=";

  subPackages = [ "cmd/bd" ];

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [ gitMinimal ];

  preCheck = ''
    export PATH="$out/bin:$PATH"
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd bd \
      --bash <($out/bin/bd completion bash) \
      --fish <($out/bin/bd completion fish) \
      --zsh <($out/bin/bd completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  meta = {
    description = "Lightweight memory system for AI coding agents with graph-based issue tracking";
    homepage = "https://github.com/steveyegge/beads";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kedry ];
    mainProgram = "bd";
  };
})
