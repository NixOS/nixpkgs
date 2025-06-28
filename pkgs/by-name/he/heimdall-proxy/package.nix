{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:
let
  version = "0.16.4";
in
buildGoModule {
  pname = "heimdall-proxy";

  inherit version;

  src = fetchFromGitHub {
    owner = "dadrus";
    repo = "heimdall";
    tag = "v${version}";
    hash = "sha256-stjdNzyL/YyCTH0omqAr1e7agK2SHwku6/Hc3337DJ8=";
  };

  vendorHash = "sha256-Oh3esrbm2bvN/n6TvrR2+odBb1oQlhE/mYtBD5dH3ic=";

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
