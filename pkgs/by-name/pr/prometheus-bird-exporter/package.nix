{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "bird-exporter";
  version = "1.7.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "bird_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7JAQogb5L5DaNrz4oHbPRlPiostSbNZZP12YpyvMJ3A=";
  };

  vendorHash = "sha256-7LvXpLHaa1lXqULn4lDcPwg58Ue2RGFp7BM7ytQZPd8=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) bird; };

  meta = {
    description = "Prometheus exporter for the bird routing daemon";
    homepage = "https://github.com/czerwonk/bird_exporter";
    changelog = "https://github.com/czerwonk/bird_exporter/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lukegb ];
    mainProgram = "bird_exporter";
  };
})
