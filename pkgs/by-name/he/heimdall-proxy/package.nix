{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:
let
  version = "0.16.5";
in
buildGoModule {
  pname = "heimdall-proxy";

  inherit version;

  src = fetchFromGitHub {
    owner = "dadrus";
    repo = "heimdall";
    tag = "v${version}";
    hash = "sha256-B1jE8oKNRn4izOEuUl9kiRw/2ZJg8uUxk1FY0EVEdlo=";
  };

  vendorHash = "sha256-utgIijvtSOfA02f/1K0NwNKZnh3YyFbeuyXA9kMU7eE=";

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
