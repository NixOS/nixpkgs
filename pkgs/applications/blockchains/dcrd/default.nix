{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "dcrd";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrd";
    rev = "refs/tags/release-v${version}";
    hash = "sha256-ZNBSIzx07zJrBxas7bHpZ8ZPDWJ4d7jumpKYj5Qmzlo=";
  };

  patches = [
    (fetchpatch {
      name = "dcrd-appdata-env-variable.patch";
      url = "https://github.com/decred/dcrd/pull/3152/commits/216132d7d852f3f2e2a6bf7f739f47ed62ac9387.patch";
      hash = "sha256-R1GzP0qVP5XW1GnSJqFOpJVnwrVi/62tL1L2mc33+Dw=";
    })
  ];

  vendorHash = "sha256-++IPB2IadXd1LC5r6f1a0UqsTG/McAf7KQAw8WKKoaE=";

  subPackages = [ "." "cmd/promptsecret" ];

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
