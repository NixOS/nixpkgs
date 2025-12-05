{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

# Tests with go 1.24 do not work. For now
# https://github.com/kovetskiy/mark/pull/581#issuecomment-2797872996
buildGoModule rec {
  pname = "mark";
  version = "15.1.0";

  src = fetchFromGitHub {
    owner = "kovetskiy";
    repo = "mark";
    rev = "v${version}";
    sha256 = "sha256-7aOzl1+Nihj2UiAAaoQAtTlxr1FSOS/0fYmeg/dYukc=";
  };

  vendorHash = "sha256-jbaDk28NIPqjf5fLOJZnsShVw5Ni14JS4J+T0GKNTbQ=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
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

  meta = with lib; {
    description = "Tool for syncing your markdown documentation with Atlassian Confluence pages";
    mainProgram = "mark";
    homepage = "https://github.com/kovetskiy/mark";
    license = licenses.asl20;
    maintainers = with maintainers; [
      rguevara84
      wrbbz
    ];
  };
}
