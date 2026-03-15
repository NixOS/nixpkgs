{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  installShellFiles,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "beads";
  version = "0.59.0";

  src = fetchFromGitHub {
    owner = "steveyegge";
    repo = "beads";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IyO0RWP98NQ8GHVsolhu80FS06aqrZjg0JprDiFdyCk=";
  };

  vendorHash = "sha256-ygZPi56fVEHaEShGVGpObFkrLs1DHrM8i2Y4BktMmpA=";

  subPackages = [ "cmd/bd" ];

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  # Skip security tests on Darwin - they check for /etc/passwd which isn't available in sandbox
  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "-skip=TestCleanupMergeArtifacts_CommandInjectionPrevention"
  ];

  preCheck = ''
    export PATH="$out/bin:$PATH"
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd bd \
      --bash <($out/bin/bd completion bash) \
      --fish <($out/bin/bd completion fish) \
      --zsh <($out/bin/bd completion zsh)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
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
