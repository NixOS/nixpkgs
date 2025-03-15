{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:
let
  version = "0.15.9";
in
buildGoModule {
  pname = "heimdall-proxy";

  inherit version;

  src = fetchFromGitHub {
    owner = "dadrus";
    repo = "heimdall";
    tag = "v${version}";
    hash = "sha256-nrYeNVSDvGTRywhTLFLylnSz1jhR/1OSKDaRj2sDe5o=";
  };

  vendorHash = "sha256-Rz1v2jusP9edDpoFaiwb7ZatuSeg9sqFS7j2JZtNJio=";

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
