{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mark";
  version = "11.2.0";

  src = fetchFromGitHub {
    owner = "kovetskiy";
    repo = "mark";
    rev = version;
    sha256 = "sha256-Pwt8HhbO+1wmEGYRny1W5HzKRWmvTneqN4fuAaKcYaA=";
  };

  vendorHash = "sha256-uokBuQquSkdbHsI3hZ7/FxE93/QOZ6jD2zB8vDPeESI=";

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
    maintainers = with maintainers; [ rguevara84 ];
  };
}
