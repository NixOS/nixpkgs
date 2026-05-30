{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:
let
  version = "0.17.15";
in
buildGoModule {
  pname = "heimdall-proxy";

  inherit version;

  src = fetchFromGitHub {
    owner = "dadrus";
    repo = "heimdall";
    tag = "v${version}";
    hash = "sha256-NuSoLULwS634FPLr8bvcLXIIO3zL9nSFcMkjriuE6G8=";
  };

  vendorHash = "sha256-mGsV453mv36Gw5XtLRcBlhXkOpXDLGS3bEpt8oZeb1M=";

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
