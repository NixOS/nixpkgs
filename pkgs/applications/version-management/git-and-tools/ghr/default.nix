{ lib
, buildGoModule
, fetchFromGitHub
, testers
, ghr
}:

buildGoModule rec {
  pname = "ghr";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "tcnksm";
    repo = "ghr";
    rev = "v${version}";
    sha256 = "sha256-947hTRfx3GM6qKDYvlKEmofqPdcmwx9V/zISkcSKALM=";
  };

  vendorSha256 = "sha256-OpWp3v1nxHJpEh2jW8MYnbaq66wx9b3DlaKzeti5N3w=";

  # Tests require a Github API token, and networking
  doCheck = false;
  doInstallCheck = true;

  passthru.tests.testVersion = testers.testVersion {
    package = ghr;
    version = "ghr version v${version}";
  };

  meta = with lib; {
    homepage = "https://github.com/tcnksm/ghr";
    description = "Upload multiple artifacts to GitHub Release in parallel";
    license = licenses.mit;
    maintainers = [ maintainers.ivar ];
  };
}
