{ lib, buildGoModule, fetchFromGitLab }:

buildGoModule rec {
  pname = "gitlab-container-registry";
  version = "3.91.0";
  rev = "v${version}-gitlab";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "container-registry";
    inherit rev;
    hash = "sha256-C6tCwVfVZ9CMP0X5NiOdPAuSz5yeu9LAnvOPrq2QLJo=";
  };

  vendorHash = "sha256-KZWdM8Q8ipsgm7OoLyOuHo+4Vg2Nve+yZtTSUDgjOW4=";

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
