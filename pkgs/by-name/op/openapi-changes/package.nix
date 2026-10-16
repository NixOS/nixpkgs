{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
  gitUpdater,
  makeWrapper,
}:

buildGoModule (finalAttrs: {
  pname = "openapi-changes";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "pb33f";
    repo = "openapi-changes";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zPDZFJuru67rw4xFSa4tMucmHiin27a112wdCpIpjiQ=";
  };

  # skip tests that require a git repository and fail in the sandbox
  checkFlags =
    let
      skippedTests = [
        "TestResolveGitRefSource"
        "TestLoadLeftRightCommits_UsesSafeDisplayLabels"
        "TestLoadCommitsFromArgs_GitRefUsesLeftRightDispatch"
        "TestReportCommand_GitRefUsesLeftRightMode"
      ];
    in
    [
      "-skip"
      "^(${lib.concatStringsSep "|" skippedTests})$"
    ];

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = [ git ];
  __darwinAllowLocalNetworking = true;

  # tests require a git repository
  preCheck = ''
    export HOME=$(mktemp -d)
    git init
    git config --global user.email "you@example.com"
    git config --global user.name "Your Name"
    git add .
    git commit -m "initial commit"
  '';

  postInstall = ''
    wrapProgram $out/bin/openapi-changes --prefix PATH : ${lib.makeBinPath [ git ]}
  '';

  vendorHash = "sha256-0Bu/UXE+EfPMEpyWh9etFCq6jpXHbRUoZOblu8T65HY=";

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    description = "World's sexiest OpenAPI breaking changes detector";
    homepage = "https://pb33f.io/openapi-changes/";
    changelog = "https://github.com/pb33f/openapi-changes/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mguentner ];
  };
})
