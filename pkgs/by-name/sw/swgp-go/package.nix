{
  buildGo126Module,
  lib,
  fetchFromGitHub,
  # doubles the binary size
  withPprof ? false,
}:

buildGo126Module (finalAttrs: {
  pname = "swgp-go";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "database64128";
    repo = "swgp-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H4fWOh1L99/uhME81uc5DwWBO2r3Ddo+MLxMy/sWZGM=";
  };

  vendorHash = "sha256-r6h3s84n6sbsyNwF5dX9c/vl9p355SYPNg1pEVu8adU=";

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
})
