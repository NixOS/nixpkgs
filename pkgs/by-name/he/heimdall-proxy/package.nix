{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:
let
  version = "0.16.0";
in
buildGoModule {
  pname = "heimdall-proxy";

  inherit version;

  src = fetchFromGitHub {
    owner = "dadrus";
    repo = "heimdall";
    tag = "v${version}";
    hash = "sha256-50LLclXdSIJ03zQ3qqF+2LlPAeIyZFaa2U2tJGFLpuk=";
  };

  vendorHash = "sha256-MFlRjTlaD6pppk5Dx0+EAtRSlVH/EOp3NKQgHbtQdRA=";

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
    description = "A cloud native Identity Aware Proxy and Access Control Decision service";
    homepage = "https://dadrus.github.io/heimdall";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ albertilagan ];
    mainProgram = "heimdall";
  };
}
