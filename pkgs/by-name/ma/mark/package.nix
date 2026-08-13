{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  iana-etc,
  libredirect,
}:

buildGoModule (finalAttrs: {
  pname = "mark";
  version = "16.8.11";

  src = fetchFromGitHub {
    owner = "kovetskiy";
    repo = "mark";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-xPMzfYZWwys9Hp3PTVzBtBg99cx4k78r/EDHi3PX2xE=";
  };

  vendorHash = "sha256-AhXMLBMn0MzBPZa7K2RO+Uk33X/KCe6ZoKAIOmuw+l0=";

  ldflags = [
    "-s"
    "-w"
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
      ];
    in
    [
      "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$"
    ];

  # confluence/api_test.go serves a mock Confluence API over httptest, which
  # binds a localhost listener.
  __darwinAllowLocalNetworking = true;

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
