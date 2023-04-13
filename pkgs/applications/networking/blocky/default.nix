{ buildGoModule
, fetchFromGitHub
, lib
, nixosTests
}:

buildGoModule rec {
  pname = "blocky";
  version = "0.21";

  src = fetchFromGitHub {
    owner = "0xERR0R";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+88QMASMEY1pJuejFUqqW1Ky7TpoSwCzUy1oueL7FKU=";
  };

  # needs network connection and fails at
  # https://github.com/0xERR0R/blocky/blob/development/resolver/upstream_resolver_test.go
  doCheck = false;

  vendorSha256 = "sha256-EsANifwaEi5PdY0Y2QZjD55sZqsqYWrC5Vh4uxpTs5A=";

  ldflags = [ "-s" "-w" "-X github.com/0xERR0R/blocky/util.Version=${version}" ];

  passthru.tests = { inherit (nixosTests) blocky; };

  meta = with lib; {
    description = "Fast and lightweight DNS proxy as ad-blocker for local network with many features.";
    homepage = "https://0xerr0r.github.io/blocky";
    changelog = "https://github.com/0xERR0R/blocky/releases";
    license = licenses.asl20;
    maintainers = with maintainers; [ ratsclub ];
  };
}
