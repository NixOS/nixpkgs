{
  lib,
  buildGoModule,
  fetchFromGitLab,
  fetchpatch,
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

  env = {
    # required for multiple azure tests
    # https://gitlab.com/gitlab-org/container-registry/-/issues/1494
    AZURE_DRIVER_VERSION = "azure_v2";
  };

  patches = [
    # remove with >= 4.15.3
    (fetchpatch {
      url = "https://gitlab.com/gitlab-org/container-registry/-/commit/268689a2f30880b7d122469a4260ca46cbc55ccd.patch";
      hash = "sha256-RslK4qvcqCaG7ju2LgN/tI9cImrTj3Nry+mCv3zoWiA=";
    })
  ];

  postPatch = ''
    # Disable flaky inmemory storage driver test
    rm registry/storage/driver/inmemory/driver_test.go

    substituteInPlace health/checks/checks_test.go \
      --replace-fail \
        'func TestHTTPChecker(t *testing.T) {' \
        'func TestHTTPChecker(t *testing.T) { t.Skip("Test requires network connection")'

    # Add workaround for failing test due to function type mismatch (args vs return) by upstream
    # https://gitlab.com/gitlab-org/container-registry/-/issues/1495
    substituteInPlace registry/storage/driver/base/regulator_test.go \
      --replace-fail \
        'require.Equal(t, limit, r.available, "r.available")' \
        'require.Equal(t, limit, int(r.available), "r.available")'
  '';

  meta = with lib; {
    description = "GitLab Docker toolset to pack, ship, store, and deliver content";
    license = licenses.asl20;
    maintainers = with maintainers; [ yayayayaka ] ++ teams.cyberus.members;
    platforms = platforms.unix;
  };
}
