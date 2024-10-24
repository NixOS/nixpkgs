{ lib, buildGoModule, fetchFromGitLab }:

buildGoModule rec {
  pname = "gitlab-container-registry";
  version = "4.11.0";
  rev = "v${version}-gitlab";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "container-registry";
    inherit rev;
    hash = "sha256-wUypldxi3O5sm4i9v2HiZjqUy/JwtcRPvCCmINCk4YU=";
  };

  vendorHash = "sha256-Ed+WvdWpEU5c9v14eM1PdCcT3qRnaRF/XeUKedPmaSU=";

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
    maintainers = with maintainers; [ yayayayaka ] ++ teams.cyberus.members;
    platforms = platforms.unix;
  };
}
