{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dcrd";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrd";
    rev = "refs/tags/release-v${version}";
    sha256 = "14pxajc8si90hnddilfm09kmljwxq6i6p53fk0g09jp000cbklkl";
  };

  vendorSha256 = "03aw6mcvp1vr01ppxy673jf5hdryd5032cxndlkaiwg005mxp1dy";

  doCheck = false;

  subPackages = [ "." "cmd/dcrctl" "cmd/promptsecret" ];

  meta = {
    homepage = "https://decred.org";
    description = "Decred daemon in Go (golang)";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ juaningan ];
  };
}
