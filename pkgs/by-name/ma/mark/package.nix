{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mark";
  version = "11.3.1";

  src = fetchFromGitHub {
    owner = "kovetskiy";
    repo = "mark";
    rev = version;
    sha256 = "sha256-gYNNh29Z65f7lAYooK0GQe3zlJ7OIpDfIQsc68UDeCc=";
  };

  vendorHash = "sha256-I3hJn2wGRB5Kr6aoyiQHEIaFAQPwUn6kDJHCFuX+nAM=";

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
