{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  ghr,
}:

buildGoModule (finalAttrs: {
  pname = "ghr";
  version = "0.18.4";

  src = fetchFromGitHub {
    owner = "tcnksm";
    repo = "ghr";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-zgRtu8RYyfBwSRs1nCOONyFLCRS6wCKqSLmqOLdJ9H0=";
  };

  vendorHash = "sha256-j5wa8rK4+gjjdJP7BlixDlztHdvSHzUeTuJKitQzc1M=";

  # Tests require a Github API token, and networking
  doCheck = false;
  doInstallCheck = true;

  passthru.tests.version = testers.testVersion {
    package = ghr;
    version = "v${finalAttrs.version}";
  };

  meta = {
    homepage = "https://github.com/tcnksm/ghr";
    description = "Upload multiple artifacts to GitHub Release in parallel";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "ghr";
  };
})
