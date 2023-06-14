{ lib, buildGoModule, fetchFromGitLab }:

buildGoModule rec {
  pname = "gitlab-container-registry";
  version = "3.76.0";
  rev = "v${version}-gitlab";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "container-registry";
    inherit rev;
    sha256 = "sha256-A9c7c/CXRs5mYSvDOdHkYOYkl+Qm6M330TBUeTnegBs=";
  };

  vendorHash = "sha256-9rO2GmoFZrNA3Udaktn8Ek9uM8EEoc0I3uv4UEq1c1k=";

  postPatch = ''
    substituteInPlace health/checks/checks_test.go \
      --replace \
        'func TestHTTPChecker(t *testing.T) {' \
        'func TestHTTPChecker(t *testing.T) { t.Skip("Test requires network connection")'
  '';

  meta = with lib; {
    description = "The GitLab Docker toolset to pack, ship, store, and deliver content";
    license = licenses.asl20;
    maintainers = with maintainers; [ yayayayaka xanderio ];
    platforms = platforms.unix;
  };
}
