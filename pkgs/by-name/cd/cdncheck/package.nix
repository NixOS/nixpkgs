{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cdncheck";
  version = "1.2.14";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "cdncheck";
    tag = "v${version}";
    hash = "sha256-6U0NaNohokLcNcC+WLKHJfQ/duUsIr2iCTpzH0CzHCQ=";
  };

  vendorHash = "sha256-bOYBSbaXRmBn8eHu25xDgkmQoPw6IwbvLyQitOJP4so=";

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

  meta = {
    description = "Tool to detect various technology for a given IP address";
    homepage = "https://github.com/projectdiscovery/cdncheck";
    changelog = "https://github.com/projectdiscovery/cdncheck/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "cdncheck";
  };
}
