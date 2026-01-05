{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:
let
  version = "0.17.6";
in
buildGoModule {
  pname = "heimdall-proxy";

  inherit version;

  src = fetchFromGitHub {
    owner = "dadrus";
    repo = "heimdall";
    tag = "v${version}";
    hash = "sha256-1QnKOxn1m91zu2HOfMyVYFHaHFrw8qn8288tv5HEiiA=";
  };

  vendorHash = "sha256-iX6vt8e9oPPUqHvX6n3OqiafKlP/SmWkfUJBRev7VZQ=";

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
