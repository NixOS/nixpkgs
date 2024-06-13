{ lib, buildGoModule, fetchFromGitHub, installShellFiles, git, testers, git-town, makeWrapper }:

buildGoModule rec {
  pname = "git-town";
  version = "14.2.1";

  src = fetchFromGitHub {
    owner = "git-town";
    repo = "git-town";
    rev = "v${version}";
    hash = "sha256-7wsN95I8Xa5CXh1Mg3Wv4gyTSRzZMqJ06ALLsud3l2k=";
  };

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles makeWrapper ];

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

  nativeCheckInputs = [ git ];

  preCheck = ''
    HOME=$(mktemp -d)
  '';

  checkFlags =
    let
      # Disable tests requiring local operations
      skippedTests = [
        "TestGodog"
        "TestMockingRunner/MockCommand"
        "TestMockingRunner/QueryWith"
        "TestTestCommands/CreateChildFeatureBranch"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall = ''
    installShellCompletion --cmd git-town \
      --bash <($out/bin/git-town completions bash) \
      --fish <($out/bin/git-town completions fish) \
      --zsh <($out/bin/git-town completions zsh)

    wrapProgram $out/bin/git-town --prefix PATH : ${lib.makeBinPath [ git ]}
  '';

  passthru.tests.version = testers.testVersion {
    package = git-town;
    command = "git-town --version";
    inherit version;
  };

  meta = with lib; {
    description = "Generic, high-level git support for git-flow workflows";
    homepage = "https://www.git-town.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ allonsy blaggacao gabyx ];
    mainProgram = "git-town";
  };
}
