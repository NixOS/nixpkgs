{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:
let
  version = "0.16.6";
in
buildGoModule {
  pname = "heimdall-proxy";

  inherit version;

  src = fetchFromGitHub {
    owner = "dadrus";
    repo = "heimdall";
    tag = "v${version}";
    hash = "sha256-IWK8iNhNw0deaj2OYlArmqBftDmSlGtVzXbu0KwB8O8=";
  };

  vendorHash = "sha256-OG7AqHS3UXBDvIT+F8USIc33MVE/i8eHVjYOY9ZWzIw=";

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
