{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  icu,
  installShellFiles,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "beads";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "gastownhall";
    repo = "beads";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D2jShGpkOWKx9aRmRvV5bmV8t0/Y2eAE8q0m54QrRN0=";
  };

  vendorHash = "sha256-7DJgqJX2HDa9gcGD8fLNHLIXvGAEivYeDYx3snCUyCE=";

  subPackages = [ "cmd/bd" ];

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ icu ];

  nativeCheckInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  # TestCheckMetadataVersionTracking: fails because the version jump from
  # 0.55.0 (hardcoded in test fixture) to 1.0.0 triggers a "very old" warning
  # instead of the expected "ok" status.
  # TestAutoMigrateOnVersionBump_NoDatabase: expects a dolt database to exist
  # for auto-migration, which is unavailable in the sandbox.
  # TestCleanupMergeArtifacts_CommandInjectionPrevention: checks /etc/passwd
  # which isn't available in the Darwin sandbox.
  checkFlags =
    let
      skipTests = [
        "TestCheckMetadataVersionTracking"
        "TestAutoMigrateOnVersionBump_NoDatabase"
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        "TestCleanupMergeArtifacts_CommandInjectionPrevention"
      ];
    in
    [ "-skip=${lib.concatStringsSep "|" skipTests}" ];

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
    homepage = "https://github.com/gastownhall/beads";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kedry ];
    mainProgram = "bd";
  };
})
