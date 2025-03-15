{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kine";
  version = "0.13.10";

  src = fetchFromGitHub {
    owner = "k3s-io";
    repo = "kine";
    rev = "v${version}";
    hash = "sha256-5GA5W5K0Zp14400XQtlsv8BfFQ91/UnNIFwBfyrBshY=";
  };

  vendorHash = "sha256-I/b4MVvqZN9eI57wPmWrP61alo9F6N1xjdx/HsNAdPQ=";

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
    description = "Kine is an etcdshim that translates etcd API to RDMS";
    homepage = "https://github.com/k3s-io/kine";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ techknowlogick ];
    mainProgram = "kine";
  };
}
