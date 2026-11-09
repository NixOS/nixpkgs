{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kine";
  version = "0.16.3";

  src = fetchFromGitHub {
    owner = "k3s-io";
    repo = "kine";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6/aaG8SE8spR0vNCHSkIRTQf5HoBnRFKjkO01uJHorc=";
  };

  vendorHash = "sha256-8AWGYrnawnPnAqGr8pDzh6ePzyuY5Q5fy4cdphYELB8=";

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
