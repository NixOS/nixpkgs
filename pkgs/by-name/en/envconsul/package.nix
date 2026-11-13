{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  envconsul,
}:

buildGoModule (finalAttrs: {
  pname = "envconsul";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "envconsul";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YJnvDNOMRlE7REDYU6NWf8/ol46ch4Tkn8AoTZPWspM=";
  };

  vendorHash = "sha256-njM8ENkXNfXApHnzWXPZZp8OFP/Fm6DDMZxoAN1zpBc=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/hashicorp/envconsul/version.Name=envconsul"
  ];

  passthru.tests.version = testers.testVersion {
    package = envconsul;
    version = "v${finalAttrs.version}";
  };

  meta = {
    homepage = "https://github.com/hashicorp/envconsul/";
    description = "Read and set environmental variables for processes from Consul";
    license = lib.licenses.mpl20;
    mainProgram = "envconsul";
  };
})
