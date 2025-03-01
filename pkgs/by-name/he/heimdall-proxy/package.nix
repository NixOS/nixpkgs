{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:
let
  version = "0.15.5";
in
buildGoModule {
  pname = "heimdall-proxy";

  inherit version;

  src = fetchFromGitHub {
    owner = "dadrus";
    repo = "heimdall";
    tag = "v${version}";
    hash = "sha256-tVWdxhdHr8HvestvGbyfstSagzwIB35Uub+9X64tTAA=";
  };

  vendorHash = "sha256-DkqM/zkatYskXQl+MOWJX3PkZGHCqyXZ0v/EEJUS3cA=";

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
