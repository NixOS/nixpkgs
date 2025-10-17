{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cdncheck";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "cdncheck";
    tag = "v${version}";
    hash = "sha256-Ty+W5uiFkr8MBhWUweHsFQnIZ8R+oJoCcvQabHFdu7U=";
  };

  vendorHash = "sha256-YjkO3QTQZlCfbKm/uYNVwnyQ/1Tde77YB2m7CqKsRtM=";

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
