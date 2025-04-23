{
  lib,
  buildGoModule,
  fetchFromGitHub,
  systemdLibs,
}:

buildGoModule rec {
  pname = "coroot-node-agent";
  version = "1.23.17";

  src = fetchFromGitHub {
    owner = "coroot";
    repo = "coroot-node-agent";
    rev = "v${version}";
    hash = "sha256-IHOS0Xh0JAWC4NvRbpTQZJ+Se5YjtT+D2gK0w1YaprY=";
  };

  vendorHash = "sha256-dX/hUWuHn5qV/wOyaaA+hnL6pp1OJ6Bw4W/UY8u1UZc=";

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
