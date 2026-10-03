{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  ghr,
}:

buildGoModule (finalAttrs: {
  pname = "ghr";
  version = "0.18.5";

  src = fetchFromGitHub {
    owner = "tcnksm";
    repo = "ghr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uUVZ26GE73LKQ/s0I4VX60EC5dLGA5UotJw0ndpSv0k=";
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
