{
  fetchFromGitHub,
  buildGo124Module,
  lib,
}:
let
  version = "0.15.7";
in
buildGo124Module {
  pname = "heimdall-proxy";

  inherit version;

  src = fetchFromGitHub {
    owner = "dadrus";
    repo = "heimdall";
    tag = "v${version}";
    hash = "sha256-vHPojkcKW3CfPavhN8s6frio46qvv0M2Ujq0bHW+VJs=";
  };

  vendorHash = "sha256-hoQYMDEEwT5g8CJBT3AGDzmv/A65DLVcS79VS/CgL8k=";

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
    mainProgram = "heimdall-proxy";
  };
}
