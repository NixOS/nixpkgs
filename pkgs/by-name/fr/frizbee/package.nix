{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "frizbee";
  version = "0.1.10";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "stacklok";
    repo = "frizbee";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DgUHGIld5T+eg9DemANE4exk0/JzMp7gBdbVtCi2nEc=";
  };

  vendorHash = "sha256-XJJ9375jJ0lN0VRO2c9QoG+1jkBmzKZG+T1DIHaLaq0=";

  nativeBuildInputs = [ installShellFiles ];

  env.CGO_ENABLED = 0;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd frizbee \
      --bash <($out/bin/frizbee completion bash) \
      --fish <($out/bin/frizbee completion fish) \
      --zsh <($out/bin/frizbee completion zsh)

    mkdir $out/share/powershell/ -p
    $out/bin/frizbee completion pwsh > $out/share/powershell/frizbee.Completion.ps1
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
    "-X main.Commit=${finalAttrs.src.rev}"
    # "-X main.CommitDate=1970-01-01" # epoch as placeholder
    "-X main.TreeState=clean"
    "-X github.com/stacklok/frizbee/internal/cli.CLIVersion=${finalAttrs.version}"
  ];

  # Skip tests that require network access.
  checkFlags = [
    "-skip"
    (lib.concatStringsSep "|" [
      "TestReplacer_ParseGitHubActionString"
      "TestReplacer_ParseGitHubActionsInFile"
      "TestGetChecksum"
    ])
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "frizbee version";
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Throw a tag at it and it comes back with a checksum";
    homepage = "https://github.com/stacklok/frizbee";
    changelog = "https://github.com/stacklok/frizbee/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lafrenierejm ];
    mainProgram = "frizbee";
  };
})
