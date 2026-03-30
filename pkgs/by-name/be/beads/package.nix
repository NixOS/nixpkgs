{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  icu,
  gitMinimal,
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

  buildInputs = [ icu ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  checkFlags = [
    "-skip=TestE2E_AutoStartedRepoLocalServerPersistsAcrossCommands|TestCheckMetadataVersionTracking"
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight memory system for AI coding agents with graph-based issue tracking";
    homepage = "https://github.com/gastownhall/beads";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kedry
      arunoruto
    ];
    mainProgram = "bd";
    platforms = lib.platforms.unix;
  };
})
