{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kine";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "k3s-io";
    repo = "kine";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+2vhvSTlBLakDuPnYDoaiBZk2o4L8eEqeX7bUqBGIbc=";
  };

  vendorHash = "sha256-q9Gd3+QoVMB18C/SI55Czra9TTdE213x8XopA0uOxh0=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/k3s-io/kine/pkg/version.Version=v${finalAttrs.version}"
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
})
