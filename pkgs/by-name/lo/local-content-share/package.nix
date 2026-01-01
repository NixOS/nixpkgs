{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "local-content-share";
<<<<<<< HEAD
  version = "36";
=======
  version = "35";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Tanq16";
    repo = "local-content-share";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-FINKuRzpAwFV2F5FFrM0B3z7sx3PG+Ql8dETwykgyu4=";
=======
    hash = "sha256-pFYkq1QqGugOVT0uMPC11ChXtxMwGv4JZKGWIqK7y3s=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  vendorHash = null;

  # no test file in upstream
  doCheck = false;

  passthru.tests.nixos = nixosTests.local-content-share;

  meta = {
    description = "Storing/sharing text/files in your local network with no setup on client devices";
    homepage = "https://github.com/Tanq16/local-content-share";
    license = lib.licenses.mit;
    mainProgram = "local-content-share";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ e-v-o-l-v-e ];
  };
})
