{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "capslock";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "google";
    repo = "capslock";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oR5+BZ2z1wPMT7hKzLIIG7Bs/8P66aXKp5YaeYRCoCs=";
  };

  vendorHash = "sha256-CZJj86VPZV0gqqY3EMs5sEsGsQEaMPBij7tnMOp7hZc=";

  subPackages = [ "cmd/capslock" ];

  env.CGO_ENABLED = "0";

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Capability analysis CLI for Go packages that informs users of which privileged operations a given package can access";
    homepage = "https://github.com/google/capslock";
    license = lib.licenses.bsd3;
    mainProgram = "capslock";
    maintainers = with lib.maintainers; [ katexochen ];
  };
})
