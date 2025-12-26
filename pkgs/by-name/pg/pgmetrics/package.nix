{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pgmetrics";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "rapidloop";
    repo = "pgmetrics";
    rev = "v${version}";
    sha256 = "sha256-kaoJZdBzx2DGvoA+aIJnfM2ORTM9xMXHaXEuUD/qqe0=";
  };

  vendorHash = "sha256-2p8BZw/GB/w99VL5NFIBpmyadNmasqrWVncpBHTyh6Q=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = {
    homepage = "https://pgmetrics.io/";
    description = "Collect and display information and stats from a running PostgreSQL server";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "pgmetrics";
  };
}
