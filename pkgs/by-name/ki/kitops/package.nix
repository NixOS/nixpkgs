{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;
  pname = "kitops";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "kitops-ml";
    repo = "kitops";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YunOq5loW+fmfWKPHZDWIpsQjrMJRs66zF1+w0iJz9I=";
  };

  vendorHash = "sha256-zSAB58nR7cFbYzFHoaq4CJdzmHbxLtyGSpQ8U/Pjcn8=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-X github.com/kitops-ml/kitops/pkg/lib/constants.Version=v${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/kitops $out/bin/kit
  '';

  # These tests start the `kit dev` server or otherwise exercise code paths
  # that contact a registry, which requires network access unavailable in
  # the build sandbox.
  checkFlags =
    let
      skippedTests = [
        "TestDevCommand"
        "TestDevDirectory"
        "TestDevReferenceExtraction"
        "TestListFormatVariants"
      ];
    in
    [ "-skip=^(${builtins.concatStringsSep "|" skippedTests})$" ];

  # `subPackages` limits the default `getGoDirs` to the root package, which has
  # no tests, so run the whole module's test suite explicitly.
  checkPhase = ''
    runHook preCheck
    export GOFLAGS=''${GOFLAGS//-trimpath/}
    go test ./... "$checkFlags"
    runHook postCheck
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  # kit's root command resolves a config home directory via $KITOPS_HOME
  # (falling back to XDG-style paths); without it the version subcommand
  # exits before printing its version, so point it at TMPDIR for the check.
  # versionCheckHook wipes the environment unless the var is listed here.
  versionCheckKeepEnvironment = [ "KITOPS_HOME" ];
  preVersionCheck = ''
    export KITOPS_HOME="$TMPDIR"
  '';

  meta = {
    description = "Open source DevOps tool for packaging and versioning AI/ML models, datasets, code, and configuration into an OCI Artifact";
    homepage = "https://github.com/kitops-ml/kitops";
    changelog = "https://github.com/kitops-ml/kitops/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ gbhu753 ];
    mainProgram = "kit";
  };
})
