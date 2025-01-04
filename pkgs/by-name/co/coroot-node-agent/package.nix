{
  lib,
  buildGoModule,
  fetchFromGitHub,
  systemdLibs,
}:

buildGoModule rec {
  pname = "coroot-node-agent";
  version = "1.23.1";

  src = fetchFromGitHub {
    owner = "coroot";
    repo = "coroot-node-agent";
    rev = "v${version}";
    hash = "sha256-kisYm0bM+IZJ9qRx1lDlcFtZIdjsNfu6Ao75q84ruDM=";
  };

  vendorHash = "sha256-EXI4xpo4j/EzugW8zyu0Dvk2i6bYFBIF+SsL6GZ+J2Q=";

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
