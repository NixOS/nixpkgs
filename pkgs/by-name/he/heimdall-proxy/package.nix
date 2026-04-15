{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:
let
  version = "0.17.13";
in
buildGoModule {
  pname = "heimdall-proxy";

  inherit version;

  src = fetchFromGitHub {
    owner = "dadrus";
    repo = "heimdall";
    tag = "v${version}";
    hash = "sha256-BJgrY3UNBPLssUh4HrWShO9BF2jW5D5q+A66y4fK5+k=";
  };

  vendorHash = "sha256-n7q49RU59AHVqrBidZ+kxgqybyiyncJm6mfNtR7lGEg=";

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
