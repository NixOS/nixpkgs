{
  lib,
  stdenv,
  buildGo127Module,
  fetchFromGitHub,
  iana-etc,
  libredirect,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGo127Module (finalAttrs: {
  pname = "mark";
  version = "16.24.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kovetskiy";
    repo = "mark";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RphGTDtXl5juBQpge7+64syFFXOTGb2SV+VoasOxYU4=";
  };

  vendorHash = "sha256-iSvyqZe/FMWZwJ8bdJMCnJWd5i2KM4pGFlIKsKoJyUA=";

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeCheckInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libredirect.hook ];

  # goldmark-katex pulls in modernc.org/libc, whose vendored netdb package reads
  # /etc/protocols and /etc/services during package init. It falls back to a
  # built-in table when they do not exist, but panics when they exist and are
  # unreadable, which is what the Darwin sandbox produces.
  preCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/services=${iana-etc}/etc/services
  '';

  checkFlags =
    let
      skippedTests = [
        # Expects to be able to launch google-chrome
        "TestExtractMermaidImage"
        "TestExtractD2Image/example"
        "TestAttachmentFilenameAttributeIsEscaped"
        "TestDiagramWithoutTitleHasNoCaption"
        "TestDiagramWithTitleKeepsCaption"
        "TestContextReplacesADeadBrowser"
        "TestContextReturnsTheSameLiveBrowser"
        "TestProcessD2SVGAndPNGAreDifferentAttachments"
        "TestMathPNGFormat"
        "TestCompileMarkdownMath"
        "TestCompileMarkdownMathPreservesEscapes"
        "TestProcessPNG"
        "TestProcessScaleChangesTheName"
        "TestProcessFormats"
        "TestProcessScaleZeroIsTheDefault"
        "TestInvalidDiagramKeepsEngine"
        "TestPNGBoundsMeasureWhatIsCaptured"
        "TestOversizedPNGIsRefusedAndKeepsEngine"
        "TestScaleZeroIsTheDefault"
        "TestRenderTimeoutKeepsEngine"
        "TestProcessMermaidSVG"
        "TestProcessMermaidWithBundle"
        "TestSVGChecksumsDifferByBundle"
        "TestSVGStatesItsOwnSizeUncapped"
        "TestSVGIsUncappedForEveryKindOfDiagram"
        "TestSVGScaleMultipliesWhatThePageShowsAndNotTheFile"
        "TestPNGIsUnaffectedByTheUncapping"
        "TestProcessMermaidFlattensASlashInTheTitle"
      ];
    in
    [
      "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$"
    ];

  # confluence/api_test.go serves a mock Confluence API over httptest, which
  # binds a localhost listener.
  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  doInstallCheck = true;

  meta = {
    description = "Tool for syncing your markdown documentation with Atlassian Confluence pages";
    mainProgram = "mark";
    homepage = "https://github.com/kovetskiy/mark";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      rguevara84
      wrbbz
    ];
  };
})
