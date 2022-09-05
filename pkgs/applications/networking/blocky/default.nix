{ buildGoModule
, fetchFromGitHub
, lib
, nixosTests
}:

buildGoModule rec {
  pname = "blocky";
  version = "0.19";

  src = fetchFromGitHub {
    owner = "0xERR0R";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jOOakRuiNbdCGmbaQFuHcLsHhV26jaQY+1GgDj9ocs0=";
  };

  # needs network connection and fails at
  # https://github.com/0xERR0R/blocky/blob/development/resolver/upstream_resolver_test.go
  doCheck = false;

  vendorSha256 = "sha256-fsMBL9qyhIrV6eAsqpSaNniibMdYRVBnl2KCzStvMGQ=";

  meta = with lib; {
    description = "Fast and lightweight DNS proxy as ad-blocker for local network with many features.";
    homepage = "https://0xerr0r.github.io/blocky";
    changelog = "https://github.com/0xERR0R/blocky/releases";
    license = licenses.asl20;
    maintainers = with maintainers; [ ratsclub ];
  };

  passthru.tests = { inherit (nixosTests) blocky; };
}
