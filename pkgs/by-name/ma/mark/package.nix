{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mark";
  version = "12.0.0";

  src = fetchFromGitHub {
    owner = "kovetskiy";
    repo = "mark";
    rev = version;
    sha256 = "sha256-kMP6+L7kfK/qfVI49ssD6Ar1c7ugKgiXUIk9yjQYXE8=";
  };

  vendorHash = "sha256-40hYy3rXyTqrmTp6lNsLI5c2GWZ6Aoi3KRPJV0Ry5Ds=";

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
