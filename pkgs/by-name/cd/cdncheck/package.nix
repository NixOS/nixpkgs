{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cdncheck";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "cdncheck";
    rev = "refs/tags/v${version}";
    hash = "sha256-1TYUSWbcWnRsOM8ctY1g9CmFSAXiK9NmN5ZDaKeJIgw=";
  };

  vendorHash = "sha256-0fiZJeBvxUib8a9CeTmYottOp+15YEdTVYhdzKSSCrk=";

  subPackages = [ "cmd/cdncheck/" ];

  ldflags = [
    "-s"
    "-w"
  ];

  preCheck = ''
    # Tests require network access
    substituteInPlace other_test.go \
      --replace-fail "TestCheckDomainWithFallback" "SkipTestCheckDomainWithFallback" \
      --replace-fail "TestCheckDNSResponse" "SkipTestCheckDNSResponse"
  '';

  meta = with lib; {
    description = "Tool to detect various technology for a given IP address";
    homepage = "https://github.com/projectdiscovery/cdncheck";
    changelog = "https://github.com/projectdiscovery/cdncheck/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "cdncheck";
  };
}
