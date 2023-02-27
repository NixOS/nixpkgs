{ buildGoModule
, fetchFromGitHub
, lib
, nixosTests
}:

buildGoModule rec {
  pname = "blocky";
  version = "0.20";

  src = fetchFromGitHub {
    owner = "0xERR0R";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-l2GhqJit/+WpNDICD/NUzCAGrKrTNHzEzgpF9k3+DLk=";
  };

  # needs network connection and fails at
  # https://github.com/0xERR0R/blocky/blob/development/resolver/upstream_resolver_test.go
  doCheck = false;

  vendorSha256 = "sha256-CS8+tsE5dptG9gF46OFoJGzn1FnfjekXLTLrpwIQdFQ=";

  ldflags = [ "-s" "-w" "-X github.com/0xERR0R/blocky/util.Version=${version}" ];

  meta = with lib; {
    description = "Fast and lightweight DNS proxy as ad-blocker for local network with many features.";
    homepage = "https://0xerr0r.github.io/blocky";
    changelog = "https://github.com/0xERR0R/blocky/releases";
    license = licenses.asl20;
    maintainers = with maintainers; [ ratsclub ];
  };

  passthru.tests = { inherit (nixosTests) blocky; };
}
