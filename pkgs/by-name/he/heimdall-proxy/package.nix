{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:
let
  version = "0.17.30";
in
buildGoModule {
  pname = "heimdall-proxy";

  inherit version;

  src = fetchFromGitHub {
    owner = "dadrus";
    repo = "heimdall";
    tag = "v${version}";
    hash = "sha256-UzPZEUwt6XlWJjnVAc2VGKcxWYQY1ht6PzMYi0PNgP0=";
  };

  vendorHash = "sha256-ySUI7nGyFAuWMwe77OBa/90P2dvPrik1kllQDgVeNDY=";

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
