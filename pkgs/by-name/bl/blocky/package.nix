{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nixosTests,
}:

buildGoModule rec {
  pname = "blocky";
  version = "0.25";

  src = fetchFromGitHub {
    owner = "0xERR0R";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-yd9qncTuzf7p1hIYHzzXyxAx1C1QiuQAIYSKcjCiF0E=";
  };

  # needs network connection and fails at
  # https://github.com/0xERR0R/blocky/blob/development/resolver/upstream_resolver_test.go
  doCheck = false;

  vendorHash = "sha256-Ck80ym64RIubtMHKkXsbN1kFrB6F9G++0U98jPvyoHw=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/0xERR0R/blocky/util.Version=${version}"
  ];

  passthru.tests = { inherit (nixosTests) blocky; };

  meta = with lib; {
    description = "Fast and lightweight DNS proxy as ad-blocker for local network with many features";
    homepage = "https://0xerr0r.github.io/blocky";
    changelog = "https://github.com/0xERR0R/blocky/releases";
    license = licenses.asl20;
    maintainers = with maintainers; [ ratsclub ];
    mainProgram = "blocky";
  };
}
