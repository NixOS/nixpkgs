{
  lib,
  buildGoModule,
  fetchFromGitLab,
}:

buildGoModule rec {
  pname = "gitlab-container-registry";
  version = "4.15.2";
  rev = "v${version}-gitlab";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "container-registry";
    inherit rev;
    hash = "sha256-nsWOCKHoryRcVT79/nbWXa0wnIflEeDLro3l21D6bzc=";
  };

  vendorHash = "sha256-aKE/yr2Sh+4yw4TmpaVF84rJOI6cjs0DKY326+aXO1o=";

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
