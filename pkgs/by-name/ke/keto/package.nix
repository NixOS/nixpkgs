{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:
let
  pname = "keto";
  version = "26.2.0";
  commit = "e4393662cd2e744deeb79de77669e07b6ccf51f3";
in
buildGoModule {
  inherit pname version commit;

  src = fetchFromGitHub {
    owner = "ory";
    repo = "keto";
    rev = "v${version}";
    hash = "sha256-wRtz4RvJ7LxVnSLmXVZFGa9QXjcPnDNJxHKosbyTed0=";
  };

  vendorHash = "sha256-B27aC4yXS36eOoq53+RWp0vq1Oqw2aR+gOjv0m+b/I4=";

  tags = [
    "sqlite"
    "json1"
    "hsm"
  ];

  subPackages = [ "." ];

  # Pass versioning information via ldflags
  ldflags = [
    "-s"
    "-w"
    "-X github.com/ory/keto/internal/driver/config.Version=${version}"
    "-X github.com/ory/keto/internal/driver/config.Commit=${commit}"
  ];

  meta = {
    description = "ORY Keto, the open source access control server";
    homepage = "https://www.ory.sh/keto/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      mrmebelman
      debtquity
    ];
  };
}
