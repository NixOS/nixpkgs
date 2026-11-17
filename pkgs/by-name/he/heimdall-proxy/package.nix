{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:
let
  version = "0.17.29";
in
buildGoModule {
  pname = "heimdall-proxy";

  inherit version;

  src = fetchFromGitHub {
    owner = "dadrus";
    repo = "heimdall";
    tag = "v${version}";
    hash = "sha256-lX3WzCt8G/0j2AzuORdqZs9e72ZMPseRIPD+pWmnfQU=";
  };

  vendorHash = "sha256-u6Ya4KsPeKNgRbIpSR3FfKD+mBOaHAJS+DZ4jNFsGrM=";

  tags = [ "sqlite" ];

  subPackages = [ "." ];

  env.CGO_ENABLED = 0;

  # Pass versioning information via ldflags
  ldflags = [
    "-s"
    "-w"
    "-X github.com/dadrus/heimdall/version.Version=${version}"
  ];

  meta = {
    description = "Cloud native Identity Aware Proxy and Access Control Decision service";
    homepage = "https://dadrus.github.io/heimdall";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ albertilagan ];
    mainProgram = "heimdall";
  };
}
