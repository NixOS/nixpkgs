{ lib, buildGoModule, fetchFromGitLab }:

buildGoModule rec {
  pname = "gitlab-container-registry";
  version = "4.5.0";
  rev = "v${version}-gitlab";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "container-registry";
    inherit rev;
    hash = "sha256-dCDybwIfzC79Mobejz/5XbEMQXkPuO8HejjannA6k/M=";
  };

  vendorHash = "sha256-sybppXCoTrc196xLBW1+sUg9Y5uA0GAptlJ7RjhzuGc=";

  postPatch = ''
    # Disable flaky inmemory storage driver test
    rm registry/storage/driver/inmemory/driver_test.go

    substituteInPlace health/checks/checks_test.go \
      --replace \
        'func TestHTTPChecker(t *testing.T) {' \
        'func TestHTTPChecker(t *testing.T) { t.Skip("Test requires network connection")'
  '';

  meta = with lib; {
    description = "GitLab Docker toolset to pack, ship, store, and deliver content";
    license = licenses.asl20;
    maintainers = with maintainers; [ yayayayaka xanderio ];
    platforms = platforms.unix;
  };
}
