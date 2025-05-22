{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nixosTests,
}:

buildGoModule rec {
  pname = "blocky";
  version = "0.26";

  src = fetchFromGitHub {
    owner = "0xERR0R";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JaATXasgzYSyx6R/7TBCJRZj0aTSf1hRW3Q22Hyhln4=";
  };

  # needs network connection and fails at
  # https://github.com/0xERR0R/blocky/blob/development/resolver/upstream_resolver_test.go
  doCheck = false;

  vendorHash = "sha256-cIDKUzOAs6XsyuUbnR2MRIeH3LI4QuohUZovh/DVJzA=";

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
