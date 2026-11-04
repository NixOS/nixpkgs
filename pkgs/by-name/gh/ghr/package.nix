{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  ghr,
}:

buildGoModule (finalAttrs: {
  pname = "ghr";
  version = "0.18.6";

  src = fetchFromGitHub {
    owner = "tcnksm";
    repo = "ghr";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-2qyplduk/fs6Du2ajkBevfUWvKLAj0mOaoNDVFGo3OM=";
  };

  vendorHash = "sha256-xUjmeB05dktpAplNl1ohzm41d3K7V9cBUuGk1IEx47Q=";

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
