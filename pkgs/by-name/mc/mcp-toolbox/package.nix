{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  stdenv,
}:
buildGoModule (finalAttrs: {
  pname = "mcp-toolbox";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "mcp-toolbox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UlvclBwUM6jsF7z43381gsxW/SLNNwRCS6Ix9pB/05U=";
    fetchSubmodules = true;
  };

  postUnpack = ''
    rm -r source/docs
  '';

  vendorHash = "sha256-UdMT7LsLcVobyK+bNSLeGki9OichFdoM4D7Isf+Ohpo=";

  proxyVendor = true;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  # ./tests holds per-source integration suites that need live databases/cloud credentials
  excludedPackages = [ "./tests" ];

  # some tests need local network access on darwin
  __darwinAllowLocalNetworking = true;

  checkFlags =
    let
      skippedTests =
        # skip tests that have network issues on MacOS
        lib.optionals stdenv.hostPlatform.isDarwin [
          "TestPrebuiltAndCustomTools"
          "TestDefaultConfigBehavior"
          "TestIgnoreUnknownToolsFlag"
          "TestServe"
          "TestRedirectLoopbackIntegration"
        ]
        ++ [
          "TestSingleEdit"
        ];
    in
    [ "-skip=${builtins.concatStringsSep "|" skippedTests}" ];

  __structuredAttrs = true;

  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "Open-source MCP server for databases";
    homepage = "https://github.com/googleapis/mcp-toolbox";
    changelog = "https://github.com/googleapis/mcp-toolbox/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pilz ];
    mainProgram = "mcp-toolbox";
  };
})
