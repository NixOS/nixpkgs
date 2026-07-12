{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:
let
  version = "0.17.17";
in
buildGoModule {
  pname = "heimdall-proxy";

  inherit version;

  src = fetchFromGitHub {
    owner = "dadrus";
    repo = "heimdall";
    tag = "v${version}";
    hash = "sha256-LRanZw1LCt1ICrQcnxFHHr89ryT6GdkO/xwkd7rlPTI=";
  };

  vendorHash = "sha256-efDG99grxfm+uIHVzYK0O/51NsaIk70E2LO2fjJ8Hxs=";

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
