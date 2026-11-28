{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  ejsonkms,
}:

buildGoModule (finalAttrs: {
  pname = "ejsonkms";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "envato";
    repo = "ejsonkms";
    rev = "v${finalAttrs.version}";
    hash = "sha256-duqdbGxndB9qRCG9ys8rvRA42kMzzec+5TdqVMmptQ4=";
  };

  vendorHash = "sha256-ar/nSS1ouo5a6QR+9veCHZ0XZsjb1dWAJwpam4MMbts=";

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
