{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:
let
  version = "0.17.7";
in
buildGoModule {
  pname = "heimdall-proxy";

  inherit version;

  src = fetchFromGitHub {
    owner = "dadrus";
    repo = "heimdall";
    tag = "v${version}";
    hash = "sha256-LpBnWzEQK+hr0XTB03rUAQ4YJ1r51nS+lK3/PL7jvNw=";
  };

  vendorHash = "sha256-GUk+nCmrk0vSFf8nt0evWKVRuwWcWmwVcLKCgVHt9GA=";

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
