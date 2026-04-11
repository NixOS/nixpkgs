{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kine";
  version = "0.14.14";

  src = fetchFromGitHub {
    owner = "k3s-io";
    repo = "kine";
    rev = "v${finalAttrs.version}";
    hash = "sha256-G1GVR0bgcx51HqwsCUqd9H30mWZgLkYYy2PNdmO/oQw=";
  };

  vendorHash = "sha256-N5FEspfnc6GexPIzN5PbX8/XYD0LXledE+mi9Ni0gTU=";

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
