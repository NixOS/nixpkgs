{ lib
, buildGoModule
, fetchFromGitHub
, testers
, ghr
}:

buildGoModule rec {
  pname = "ghr";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "tcnksm";
    repo = "ghr";
    rev = "v${version}";
    sha256 = "sha256-swu+hj8fL/xIC3KdhGQ2Ezdt7aj9L8sU/7q/AXM2i98=";
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
    maintainers = [ maintainers.ivar ];
  };
}
