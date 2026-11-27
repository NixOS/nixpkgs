{
  lib,
  stdenv,
  buildGo127Module,
  fetchFromGitHub,
  git,
  installShellFiles,
  nix-update-script,
  procps,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:

buildGo127Module (finalAttrs: {
  pname = "crush";
  version = "0.103.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "crush";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DVKLsjeut2+q7LHHWIwpJXLacga8G/EaJBJmqBAi8Xs=";
  };

  vendorHash = "sha256-OajHilzqIsX0L/1kBgjlj2XwJilWv4kGl3ILZyPBaak=";

  ldflags = [
    "-s"
    "-X=github.com/charmbracelet/crush/internal/version.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  checkFlags =
    let
      # these tests fail in the sandbox
      skippedTests = [
        "TestCoderAgent"
        "TestOpenAIClientStreamChoices"
        "TestGrepWithIgnoreFiles"
        "TestSearchImplementations"
        "TestDispatch_BinaryPassthroughExecutes"
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        "TestServiceDetectsRealProcess"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    git
    writableTmpDirAsHomeHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    procps
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd crush \
      --bash <($out/bin/crush completion bash) \
      --fish <($out/bin/crush completion fish) \
      --zsh <($out/bin/crush completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Glamourous AI coding agent for your favourite terminal";
    homepage = "https://github.com/charmbracelet/crush";
    changelog = "https://github.com/charmbracelet/crush/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.fsl11Mit;
    maintainers = with lib.maintainers; [
      x123
      malik
      davinci42
    ];
    mainProgram = "crush";
  };
})
