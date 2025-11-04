{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libredirect,
  iana-etc,
  stdenv,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "scip";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "scip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l68xhOMgwt+ySChk7BCyklcuC6r51GgobAg3lRLvOCU=";
  };

  vendorHash = "sha256-8HgeG/SXkM7ptOwKSi/PUH3VySxFqqoIpXI7bZtbO4A=";

  ldflags = [
    "-s"
    "-X=main.Reproducible=true"
  ];

  nativeCheckInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libredirect.hook
    iana-etc
  ];

  __darwinAllowLocalNetworking = true;

  # Provide /etc/protocols for SQLite tests
  preCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/services=${iana-etc}/etc/services
  '';

  # Skip tests has logic error or missing test file.
  checkFlags = [
    "-skip=TestLessCompareConsistent|TestParseCompat|TestParseSymbol_ZeroAllocationsIfMemoryAvailable|"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libredirect.hook
    iana-etc
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "SCIP Code Intelligence Protocol CLI";
    homepage = "https://github.com/sourcegraph/scip";
    changelog = "https://github.com/sourcegraph/scip/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "scip";
  };
})
