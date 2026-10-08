{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  ejsonkms,
}:

buildGoModule (finalAttrs: {
  pname = "ejsonkms";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "envato";
    repo = "ejsonkms";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uvTIyc3z8rpculfmiV8ojQ5K70R5cwP7IQPrM5teSQQ=";
  };

  vendorHash = "sha256-RXzZ+5CqVBcGAYB/IiPG8Mu4fUAgE0xr1UUVMqWTwEw=";

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
