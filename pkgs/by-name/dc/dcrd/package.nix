{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
}:

buildGoModule rec {
  pname = "dcrd";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrd";
    tag = "release-v${version}";
    hash = "sha256-nSocqwXgJhvfbdElddbb1gGxoygmtVtK6DbiSuMxYew=";
  };

  patches = [
    (fetchpatch {
      name = "dcrd-appdata-env-variable.patch";
      url = "https://github.com/decred/dcrd/pull/3152/commits/216132d7d852f3f2e2a6bf7f739f47ed62ac9387.patch";
      hash = "sha256-R1GzP0qVP5XW1GnSJqFOpJVnwrVi/62tL1L2mc33+Dw=";
    })
  ];

  vendorHash = "sha256-Napcfj1+KjQ21Jb/qpIzg2W/grzun2Pz5FV5yIBXoTo=";

  subPackages = [
    "."
    "cmd/promptsecret"
  ];

  __darwinAllowLocalNetworking = true;

  preCheck = ''
    export DCRD_APPDATA="$TMPDIR"
  '';

  meta = {
    homepage = "https://decred.org";
    description = "Decred daemon in Go (golang)";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ juaningan ];
  };
}
