{ lib, buildGoModule, fetchFromGitLab }:

buildGoModule rec {
  pname = "gitlab-container-registry";
  version = "3.90.0";
  rev = "v${version}-gitlab";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "container-registry";
    inherit rev;
    hash = "sha256-bHRvvmVQFsdgYmVVucu1warn+SvCoIVh+C/U2uwi12E=";
  };

  vendorHash = "sha256-Zv5Xz1T/ZUM/kyEgZJKbDuIN2nufoHVAn4kD3SuvJCg=";

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
