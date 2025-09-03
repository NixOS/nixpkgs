{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kine";
  version = "0.13.19";

  src = fetchFromGitHub {
    owner = "k3s-io";
    repo = "kine";
    rev = "v${version}";
    hash = "sha256-UL1HhN5qWgtzltY4eAU9SlnK80tKUHBORMFHunDCi+Q=";
  };

  vendorHash = "sha256-1Dwu1b6y1ibGt7w6Iu3lKWItwVn9H/TQFbTL2z2rVoc=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/k3s-io/kine/pkg/version.Version=v${version}"
    "-X github.com/k3s-io/kine/pkg/version.GitCommit=unknown"
  ];

  env = {
    "CGO_CFLAGS" = "-DSQLITE_ENABLE_DBSTAT_VTAB=1 -DSQLITE_USE_ALLOCA=1";
  };

  meta = {
    description = "etcdshim that translates etcd API to RDMS";
    homepage = "https://github.com/k3s-io/kine";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ techknowlogick ];
    mainProgram = "kine";
  };
}
