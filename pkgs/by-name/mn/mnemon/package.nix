{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mnemon";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "mnemon-dev";
    repo = "mnemon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BbD0jDdbwXNNiM8W9F+ijh7XYhtCxBcpguVfYnPnYe0=";
  };

  vendorHash = "sha256-nIXIk9j3duX0wbzwc8PALs3mJq88LEalYXLWRgWqfqE=";

  __structuredAttrs = true;

  ldflags = [
    "-s"
    "-X github.com/mnemon-dev/mnemon/cmd.version=${finalAttrs.version}"
  ];

  checkFlags = [
    # TestExecuteRoutesAgencyWithoutChangingItsExitCode checks an unstamped
    # 'dev' version, but nixpkgs stamps the version with 'ldflags'.
    "-skip"
    "TestExecuteRoutesAgencyWithoutChagingItsExitCode"
    # TestReleaseRepositoryHygiene runs `git ls-files` against the source
    # tree to check for sensetive files.
    "TestReleaseRepositoryHygiene"
  ];

  meta = {
    description = "LLM-supervised persistent memory for AI agents";
    homepage = "https://github.com/mnemon-dev/mnemon#readme";
    changelog = "https://github.com/mnemon-dev/mnemon/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "mnemon";
    maintainers = with lib.maintainers; [ EllianCarlos ];
  };
})
