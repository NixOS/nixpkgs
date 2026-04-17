{
  lib,
  stdenv,
  buildGoModule,
  dolt,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
  icu,
  installShellFiles,
  makeBinaryWrapper,
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

  buildInputs = [
    icu
  ];

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  nativeCheckInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  # Workaround for: panic: httptest: failed to listen on a port: listen tcp6 [::1]:0: bind: operation not permitted
  # ref: https://github.com/NixOS/nix/pull/1646
  __darwinAllowLocalNetworking = true;

  checkFlags =
    let
      skippedTests = [
        # Upstream test bug: version gap 0.55.0->1.0.0 triggers "very old" warning instead of expected "ok"
        "TestCheckMetadataVersionTracking"
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        # Checks for /etc/passwd which isn't available in sandbox
        "TestCleanupMergeArtifacts_CommandInjectionPrevention"
      ];
    in
    [ "-skip=^(${lib.concatStringsSep "|" skippedTests})$" ];

  preCheck = ''
    export PATH="$out/bin:$PATH"
  '';

  postInstall = ''
    wrapProgram $out/bin/bd \
      --prefix PATH : ${lib.makeBinPath [ dolt ]}
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
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
      imcvampire
    ];
    mainProgram = "bd";
  };
})
