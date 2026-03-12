{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

# Tests with go 1.24 do not work. For now
# https://github.com/kovetskiy/mark/pull/581#issuecomment-2797872996
buildGoModule (finalAttrs: {
  pname = "mark";
  version = "15.4.0";

  src = fetchFromGitHub {
    owner = "kovetskiy";
    repo = "mark";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-s7BQKSr/wP7obryh4tLK8rdgV8hr6U6QeCrJt9EeY3o=";
  };

  vendorHash = "sha256-s4+fB5ZkKnbuRfYOc0HWKgXAz38AjLBqU+p91Djgy0w=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  checkFlags =
    let
      skippedTests = [
        # Expects to be able to launch google-chrome
        "TestExtractMermaidImage"
        "TestExtractD2Image/example"
      ];
    in
    [
      "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$"
    ];

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
