{
  fetchFromGitHub,
  buildGo124Module,
  lib,
}:
let
  version = "0.15.8";
in
buildGo124Module {
  pname = "heimdall-proxy";

  inherit version;

  src = fetchFromGitHub {
    owner = "dadrus";
    repo = "heimdall";
    tag = "v${version}";
    hash = "sha256-UUQWYChZEb/5mc2YYwIJSQ+pCUXIwvB09KaR0FoKrA4=";
  };

  vendorHash = "sha256-4bnVqUV3H/mZ9FiApZk6pVbRWAqpy17+/dGxXR0fjW0=";

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
