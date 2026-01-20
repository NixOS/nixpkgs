{
  buildGoModule,
  lib,
  fetchFromGitHub,
  # doubles the binary size
  withPprof ? false,
}:

buildGoModule {
  pname = "swgp-go";
  version = "1.8.0-0-unstable-2026-01-18";

  src = fetchFromGitHub {
    owner = "database64128";
    repo = "swgp-go";
    rev = "e8ed210b0a016c450ba371ee43041f2f53444841";
    hash = "sha256-LDYNQwc6vdVkI0bqD96p64D25fz0aGclFDc8SqvCdJQ=";
  };

  vendorHash = "sha256-Ghv5FwSPQSUFQ1t2zWTXpFggCA4/qrQmnVYkYBF8AQ4=";

  ldflags = [
    "-s"
    "-w"
  ];

  tags = lib.optionals (!withPprof) [
    "swgpgo_nopprof"
  ];

  # Tests try to do DNS lookups
  doCheck = false;

  meta = {
    description = "Simple WireGuard proxy with minimal overhead for WireGuard traffic";
    homepage = "https://github.com/database64128/swgp-go";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      flokli
      rvdp
    ];
    mainProgram = "swgp-go";
  };
}
