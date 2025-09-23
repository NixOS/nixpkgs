{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cdncheck";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "cdncheck";
    tag = "v${version}";
    hash = "sha256-2+o2CIR8zcoOxdg8Cp+E1U3mjrxQhLUGuMTep0bXnMo=";
  };

  vendorHash = "sha256-21giZLgfNgDouU+T/8N28BEbJP2u44A3glZOwDBaiHY=";

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
