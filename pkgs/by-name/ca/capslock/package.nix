{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "capslock";
<<<<<<< HEAD
  version = "0.3.1";
=======
  version = "0.3.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "google";
    repo = "capslock";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-Ln2NqyIlFGlPZL4rbmlY+fnJFCVVaKWmwQxhE2h7e2E=";
  };

  vendorHash = "sha256-ObQvJwebefu8hIBd+dcs3i3xhRfFax1TIBDPfaTUKOY=";
=======
    hash = "sha256-ls7+aXEelxKXhittK4orv9xgPKw1pE87yZdoSHBUgK8=";
  };

  vendorHash = "sha256-2nK+yxgLmrXjt41gYSXvkpZ2glu6PAtO18Nrt1tmup4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
