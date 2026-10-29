{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:
let
  version = "0.17.19";
in
buildGoModule {
  pname = "heimdall-proxy";

  inherit version;

  src = fetchFromGitHub {
    owner = "dadrus";
    repo = "heimdall";
    tag = "v${version}";
    hash = "sha256-O1qqME2k2SggvYPlqX61wQn9yeh8skqe9Fjsc/GhUPc=";
  };

  vendorHash = "sha256-85Aty7bCV7sq4CDAk7CCGQuD18P1Uj1AMO191k+YAHY=";

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
