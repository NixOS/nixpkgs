{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "capslock";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "capslock";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ls7+aXEelxKXhittK4orv9xgPKw1pE87yZdoSHBUgK8=";
  };

  vendorHash = "sha256-2nK+yxgLmrXjt41gYSXvkpZ2glu6PAtO18Nrt1tmup4=";

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
