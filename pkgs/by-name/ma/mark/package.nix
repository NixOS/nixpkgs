{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mark";
  version = "12.1.2";

  src = fetchFromGitHub {
    owner = "kovetskiy";
    repo = "mark";
    rev = version;
    sha256 = "sha256-t70Od27w/ZT/EHKAgjPBx39Oo4dS1aWL3up7TVlNAuI=";
  };

  vendorHash = "sha256-XPTnsV0JVSatfHzI4ajq8nnN2HTKc8FeKwmOIuXo2GU=";

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
