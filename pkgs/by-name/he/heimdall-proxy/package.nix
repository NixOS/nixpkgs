{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:
let
  version = "0.17.12";
in
buildGoModule {
  pname = "heimdall-proxy";

  inherit version;

  src = fetchFromGitHub {
    owner = "dadrus";
    repo = "heimdall";
    tag = "v${version}";
    hash = "sha256-LwvizSMmMzcKl3BbPZAXLJkpxyLkz75uSL12PxgrrCM=";
  };

  vendorHash = "sha256-W0XhE9wcnLT9pVe5hNuDbkX1egsuS7x6ueBscVDztsA=";

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
