{
  lib,
  buildGoModule,
  fetchFromGitLab,
  fetchpatch,
}:

buildGoModule rec {
  pname = "gitlab-container-registry";
  version = "4.16.0";
  rev = "v${version}-gitlab";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "container-registry";
    inherit rev;
    hash = "sha256-PnX2pLbNqeJmvs+nFiCVW+sYVt8AJ7CEexGcYV7IN4U=";
  };

  vendorHash = "sha256-oNQoKn8GPJxmUzkUHGzax2/KWyI3VXLRtAvWe9B64Ds=";

  postPatch = ''
    substituteInPlace health/checks/checks_test.go \
      --replace-fail \
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
