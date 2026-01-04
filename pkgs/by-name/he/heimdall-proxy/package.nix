{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:
let
  version = "0.17.4";
in
buildGoModule {
  pname = "heimdall-proxy";

  inherit version;

  src = fetchFromGitHub {
    owner = "dadrus";
    repo = "heimdall";
    tag = "v${version}";
    hash = "sha256-0/2q+ci6bvat8oI3MW/QfI747RDuk55LNciy7RSNLZE=";
  };

  vendorHash = "sha256-3ecwQ6CHPbOouDJzDZA0S/8aJ0lUbhVnZcGby/iCxDk=";

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
