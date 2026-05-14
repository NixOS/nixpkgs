{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  ejsonkms,
}:

buildGoModule (finalAttrs: {
  pname = "ejsonkms";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "envato";
    repo = "ejsonkms";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AvOHsmcubKZH9uMwE/iwlC4ORAc9ie0H3Nyq2n+CDCs=";
  };

  vendorHash = "sha256-6C/hZwqB6yqFjfDe+KQAY+ja41v/FVaEmPEUXb0FZTA=";

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
