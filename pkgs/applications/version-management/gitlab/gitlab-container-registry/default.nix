{ lib, buildGoModule, fetchFromGitLab }:

buildGoModule rec {
  pname = "gitlab-container-registry";
  version = "3.77.0";
  rev = "v${version}-gitlab";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "container-registry";
    inherit rev;
    sha256 = "sha256-tHNxPwm1h1wyXuzUUadz5YcRkPdc0QeayMIRt292uf8=";
  };

  vendorHash = "sha256-/ITZBh0vRYHb6fDUZQNRwW2pmQulJlDZ8EbObUBtsz4=";

  patches = [
    ./Disable-inmemory-storage-driver-test.patch
  ];

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
