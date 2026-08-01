{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:
let
  version = "0.17.18";
in
buildGoModule {
  pname = "heimdall-proxy";

  inherit version;

  src = fetchFromGitHub {
    owner = "dadrus";
    repo = "heimdall";
    tag = "v${version}";
    hash = "sha256-XNcUn/Xr1zYEfURX1POwGdSZqdmPTA8SqRzP+4qNECE=";
  };

  vendorHash = "sha256-r2IpMllA8EDCGwz91qXhsRR2LoTqRbxPXfN6PIJWvqk=";

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
