{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ionosctl";
  version = "6.9.0";

  src = fetchFromGitHub {
    owner = "ionos-cloud";
    repo = "ionosctl";
    tag = "v${version}";
    hash = "sha256-x1JxLjsk3L30UI95rrn+M9v9QxMLRkWGr1P9Jq6BPyE=";
  };

  vendorHash = null;

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/ionos-cloud/ionosctl/v6/internal/version.Version=${version}"
  ];

  meta = {
    description = "CLI tool to manage your IONOS Cloud resources";
    homepage = "https://github.com/ionos-cloud/ionosctl";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.p-alik ];
    mainProgram = "ionosctl";
    platforms = lib.platforms.unix;
  };
}
