{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "blocky";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "0xERR0R";
    repo = "blocky";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mVHPnff6NEAgehEgrrIsGBeR05fHlzRMpXWCs6jsUz0=";
  };

  # needs network connection and fails at
  # https://github.com/0xERR0R/blocky/blob/development/resolver/upstream_resolver_test.go
  doCheck = false;

  vendorHash = "sha256-fIbykVKC7CiVRh/SIaLpSkV1emVchrvFwRFotTpOInQ=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/0xERR0R/blocky/util.Version=${finalAttrs.version}"
  ];

  passthru.tests = { inherit (nixosTests) blocky; };

  meta = {
    description = "Fast and lightweight DNS proxy as ad-blocker for local network with many features";
    homepage = "https://0xerr0r.github.io/blocky";
    changelog = "https://github.com/0xERR0R/blocky/releases";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      ratsclub
      kuflierl
    ];
    mainProgram = "blocky";
  };
})
