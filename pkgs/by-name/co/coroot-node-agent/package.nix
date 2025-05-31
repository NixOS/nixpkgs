{
  lib,
  buildGoModule,
  fetchFromGitHub,
  systemdLibs,
}:

buildGoModule rec {
  pname = "coroot-node-agent";
  version = "1.24.0";

  src = fetchFromGitHub {
    owner = "coroot";
    repo = "coroot-node-agent";
    rev = "v${version}";
    hash = "sha256-48bKV1z5D8FhRIm5cl5PcJ2pVGux6sV985Hk855B8Ng=";
  };

  vendorHash = "sha256-wOR0xdI+5oP+wZwyXKgWHQyUVMNH7yRk1h1m4vCEXTs=";

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
