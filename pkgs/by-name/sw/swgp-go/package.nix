{
  buildGo126Module,
  lib,
  fetchFromGitHub,
  # doubles the binary size
  withPprof ? false,
}:

buildGo126Module (finalAttrs: {
  pname = "swgp-go";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "database64128";
    repo = "swgp-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GnWcpAXViyO0T9u/AwVPr0SxvohuX+60C8j2kZbyKD0=";
  };

  vendorHash = "sha256-qiFFXL2nFZhsUsAZ98FRS2kF4ROaQUat5Skceh1DWaQ=";

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
