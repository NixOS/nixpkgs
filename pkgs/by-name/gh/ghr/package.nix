{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  ghr,
}:

buildGoModule (finalAttrs: {
  pname = "ghr";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "tcnksm";
    repo = "ghr";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Dh6po4sdNbxk3PICJLqfpwf0WmSkfzQNZ0FrCb6XXes=";
  };

  vendorHash = "sha256-zn39fh8uX7NN0IAIjBCftP6zfzvK7T6/LPp/awIujtg=";

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
