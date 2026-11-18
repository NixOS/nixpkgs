{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "rush-parallel";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "shenwei356";
    repo = "rush";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B17eFbVpTx9aaSadtnLTzHHbQwSf/6glsm5mfYwiuso=";
  };

  vendorHash = "sha256-+WykyqJQ5S23GHxvUDZbymrews17Ol9t+Wl6Lq2qVUw=";

  ldflags = [
    "-s"
    "-w"
  ];

  checkFlags =
    let
      skippedTests = [
        # inspects /proc/<pid>/exe of a long-named executable, which fails in the build sandbox
        "TestLinuxLongExecutableExclusions"
      ];
    in
    [ "-skip=^${lib.concatStringsSep "$|^" skippedTests}$" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Cross-platform command-line tool for executing jobs in parallel";
    homepage = "https://github.com/shenwei356/rush";
    changelog = "https://github.com/shenwei356/rush/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kamadorueda ];
    mainProgram = "rush";
  };
})
