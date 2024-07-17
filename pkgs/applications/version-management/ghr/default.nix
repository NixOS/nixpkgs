{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  ghr,
}:

buildGoModule rec {
  pname = "ghr";
  version = "0.16.2";

  src = fetchFromGitHub {
    owner = "tcnksm";
    repo = "ghr";
    rev = "v${version}";
    sha256 = "sha256-xClqqTVCEGghaf63kN40mwo49lkS8KC4k/36NYIngFI=";
  };

  vendorHash = "sha256-Wzzg66yJaHJUCfC2aH3Pk+B0d5l/+L7/bcNhQxo8ro0=";

  # Tests require a Github API token, and networking
  doCheck = false;
  doInstallCheck = true;

  passthru.tests.version = testers.testVersion {
    package = ghr;
    version = "v${version}";
  };

  meta = with lib; {
    homepage = "https://github.com/tcnksm/ghr";
    description = "Upload multiple artifacts to GitHub Release in parallel";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "ghr";
  };
}
