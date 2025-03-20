{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cdncheck";
  version = "1.1.9";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "cdncheck";
    tag = "v${version}";
    hash = "sha256-p03OQAA/6WX2RJfnpFi9PYvVTBwBJX2bWxbDg+anybI=";
  };

  vendorHash = "sha256-/1REkZ5+sz/H4T4lXhloz7fu5cLv1GoaD3dlttN+Qd4=";

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
