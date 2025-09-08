{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  git,
  testers,
  git-town,
  makeWrapper,
  writableTmpDirAsHomeHook,
}:

buildGoModule rec {
  pname = "git-town";
  version = "21.5.0";

  src = fetchFromGitHub {
    owner = "git-town";
    repo = "git-town";
    tag = "v${version}";
    hash = "sha256-H0WfUBrXPkqS2UnZpL6TyguzOa34KMetCwMKIvNKJ28=";
  };

  vendorHash = null;

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  buildInputs = [ git ];

  ldflags =
    let
      modulePath = "github.com/git-town/git-town/v${lib.versions.major version}";
    in
    [
      "-s"
      "-w"
      "-X ${modulePath}/src/cmd.version=v${version}"
      "-X ${modulePath}/src/cmd.buildDate=nix"
    ];

  nativeCheckInputs = [
    git
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    # this runs tests requiring local operations
    rm main_test.go
  '';

  checkFlags =
    let
      # Disable tests requiring local operations
      skippedTests = [
        "TestGodog"
        "TestMockingRunner/MockCommand"
        "TestMockingRunner/MockCommitMessage"
        "TestMockingRunner/QueryWith"
        "TestTestCommands/CreateChildFeatureBranch"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall =
    lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd git-town \
        --bash <($out/bin/git-town completions bash) \
        --fish <($out/bin/git-town completions fish) \
        --zsh <($out/bin/git-town completions zsh)
    ''
    + ''
      wrapProgram $out/bin/git-town --prefix PATH : ${lib.makeBinPath [ git ]}
    '';

  passthru.tests.version = testers.testVersion {
    package = git-town;
    command = "git-town --version";
    inherit version;
  };

  meta = {
    description = "Generic, high-level git support for git-flow workflows";
    homepage = "https://www.git-town.com/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      allonsy
      gabyx
    ];
    mainProgram = "git-town";
  };
}
