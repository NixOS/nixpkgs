{
  lib,
  buildGoModule,
  fetchFromGitHub,
  systemdLibs,
}:

buildGoModule rec {
  pname = "coroot-node-agent";
  version = "1.25.5";

  src = fetchFromGitHub {
    owner = "coroot";
    repo = "coroot-node-agent";
    rev = "v${version}";
    hash = "sha256-TIUl3DGidIgPFPh9dBkLRRIHK7gMtoXGJDehKltQ0CE=";
  };

  vendorHash = "sha256-QvdFW/o481F85WuXNdz99Q9MBiGRjVSWvPRytq67vYU=";

  buildInputs = [ systemdLibs ];

  CGO_CFLAGS = "-I ${systemdLibs}/include";

  meta = {
    description = "Prometheus exporter based on eBPF";
    homepage = "https://github.com/coroot/coroot-node-agent";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ errnoh ];
    mainProgram = "coroot-node-agent";
  };
}
