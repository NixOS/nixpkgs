{
  lib,
  stdenv,
  buildGo124Module,
  fetchFromGitHub,
  libredirect,
  iana-etc,
  versionCheckHook,
}:

buildGo124Module (finalAttrs: {
  pname = "scip";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "scip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZyU1CmDBVDNP6zCXpvqEoQ3ttWNPGLCIjkj4mezUcKc=";
  };

  vendorHash = "sha256-RwBlzBqGd/xEaTL6m3sm6e/tcNUc7Mfdf213qzuMPug=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Reproducible=true"
  ];

  nativeCheckInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libredirect.hook ];

  checkFlags =
    let
      skippedTests = [
        "TestParseCompat" # could not locate sample indexes directory starting from parents of working directory
        "TestParseSymbol_ZeroAllocationsIfMemoryAvailable"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  __darwinAllowLocalNetworking = true;

  preCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/services=${iana-etc}/etc/services
  '';

  doInstallCheck = stdenv.hostPlatform.isLinux;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "--version";

  meta = {
    description = "SCIP Code Intelligence Protocol CLI";
    mainProgram = "scip";
    homepage = "https://github.com/sourcegraph/scip";
    changelog = "https://github.com/sourcegraph/scip/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [  ];
  };
})
