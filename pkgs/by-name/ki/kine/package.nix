{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kine";
  version = "0.14.11";

  src = fetchFromGitHub {
    owner = "k3s-io";
    repo = "kine";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4MbzSRgzh2m5V4Pn9EnDmyyotD1Cv2i2uWmyVPc80bk=";
  };

  vendorHash = "sha256-RyL7N0n7Nacq0UZc4+bY2vD9sXZnJiX2HaEWtP51k8E=";

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
