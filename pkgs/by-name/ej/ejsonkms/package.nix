{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  ejsonkms,
}:

buildGoModule (finalAttrs: {
  pname = "ejsonkms";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "envato";
    repo = "ejsonkms";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PoFRKnh9XMXOPn2kj9UCzO0ahom+c4bSvxszNQ941L0=";
  };

  vendorHash = "sha256-GHLS5fQo65vS0uEo0xTC9oiznmwW27wvu7TYl0BjqR4=";

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
