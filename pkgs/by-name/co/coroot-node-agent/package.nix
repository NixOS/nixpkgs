{
  lib,
  buildGoModule,
  fetchFromGitHub,
  systemdLibs,
}:

buildGoModule rec {
  pname = "coroot-node-agent";
  version = "1.27.4";

  src = fetchFromGitHub {
    owner = "coroot";
    repo = "coroot-node-agent";
    rev = "v${version}";
    hash = "sha256-G1WFU7A0ibGsAZfpmIRQN4GR5LBKliMDDLnNnYqo4d8=";
  };

  vendorHash = "sha256-sjdUjnBMzEfGCVOwuL9Zw/5Lup3yUf5LoBajLOCNteA=";

  buildInputs = [ systemdLibs ];

  CGO_CFLAGS = "-I ${systemdLibs}/include";

  ldflags = [
    "-extldflags='-Wl,-z,lazy'"
    "-X 'github.com/coroot/coroot-node-agent/flags.Version=${version}'"
  ];

  meta = {
    description = "Prometheus exporter based on eBPF";
    homepage = "https://github.com/coroot/coroot-node-agent";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ errnoh ];
    mainProgram = "coroot-node-agent";
  };
}
