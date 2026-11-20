{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  ejsonkms,
}:

buildGoModule (finalAttrs: {
  pname = "ejsonkms";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "envato";
    repo = "ejsonkms";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GTCLtr08jpx0j4KXyrqSVZkD0YTdN4Qpm8gZjPzYbjM=";
  };

  vendorHash = "sha256-2v39BWX3b99yOrQI77j4I875Y6Su6/YyRpRFJ8iTgTI=";

  ldflags = [
    "-X main.version=v${finalAttrs.version}"
    "-s"
    "-w"
  ];

  doCheck = false;

  passthru.tests = {
    version = testers.testVersion {
      package = ejsonkms;
      version = "v${finalAttrs.version}";
    };
  };

  meta = {
    description = "Integrates EJSON with AWS KMS";
    homepage = "https://github.com/envato/ejsonkms";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ viraptor ];
  };
})
