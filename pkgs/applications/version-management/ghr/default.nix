{ lib
, buildGoModule
, fetchFromGitHub
, testers
, ghr
}:

buildGoModule rec {
  pname = "ghr";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "tcnksm";
    repo = "ghr";
    rev = "v${version}";
    sha256 = "sha256-aD1HEdoAPFFpJL++fLZIk+pIs+qDNYbTGDMlcRjV6M4=";
  };

  vendorSha256 = "sha256-pqwJPo3ZhsXU1RF4BKPOWQS71+9EitSSTE1+sKlc9+s=";

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
