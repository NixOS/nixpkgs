{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:
let
  version = "0.16.2";
in
buildGoModule {
  pname = "heimdall-proxy";

  inherit version;

  src = fetchFromGitHub {
    owner = "dadrus";
    repo = "heimdall";
    tag = "v${version}";
    hash = "sha256-RzRjcg9GocqXpBh8C34LrSLbSrJWd9y4+YEWJaAD8d0=";
  };

  vendorHash = "sha256-GVUO5a6m85C7JRJ9WBTB7JDHRaiU2Nq3clWQUedKp98=";

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
