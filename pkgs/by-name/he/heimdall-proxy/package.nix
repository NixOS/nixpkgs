{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:
let
  version = "0.16.1";
in
buildGoModule {
  pname = "heimdall-proxy";

  inherit version;

  src = fetchFromGitHub {
    owner = "dadrus";
    repo = "heimdall";
    tag = "v${version}";
    hash = "sha256-HP2YuipqqToTD44FreKtdJErtF4CWxnMf2JRmjgLuv0=";
  };

  vendorHash = "sha256-9AOUgQEhOUzzT+qJLE7NlPqiQDQHJnLOT9JSwpetQXA=";

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
