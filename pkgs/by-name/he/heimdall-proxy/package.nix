{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:
let
  version = "0.17.20";
in
buildGoModule {
  pname = "heimdall-proxy";

  inherit version;

  src = fetchFromGitHub {
    owner = "dadrus";
    repo = "heimdall";
    tag = "v${version}";
    hash = "sha256-caqt0l+o+u7F+Lyx4GQnLDGXHl8zdpEcewD0mXbeAzM=";
  };

  vendorHash = "sha256-rK/LFDeQ0XyUc24up0EqLp3a4AaiQPutRitlQHOM7Bc=";

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
