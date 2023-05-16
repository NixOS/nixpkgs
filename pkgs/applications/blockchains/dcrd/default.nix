<<<<<<< HEAD
{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "dcrd";
  version = "1.8.0";
=======
{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dcrd";
  version = "1.5.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrd";
    rev = "refs/tags/release-v${version}";
<<<<<<< HEAD
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
=======
    sha256 = "14pxajc8si90hnddilfm09kmljwxq6i6p53fk0g09jp000cbklkl";
  };

  vendorSha256 = "03aw6mcvp1vr01ppxy673jf5hdryd5032cxndlkaiwg005mxp1dy";

  doCheck = false;

  subPackages = [ "." "cmd/dcrctl" "cmd/promptsecret" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = {
    homepage = "https://decred.org";
    description = "Decred daemon in Go (golang)";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ juaningan ];
  };
}
