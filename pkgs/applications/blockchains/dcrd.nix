{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dcrd";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrd";
    rev = "refs/tags/release-v${version}";
    sha256 = "1ggw289y1f4dqvj3w60q9bahq8bblbfjymn5xy04ldylr3qlxm9x";
  };

  vendorSha256 = "03aw6mcvp1vr01ppxy673jf5hdryd5032cxndlkaiwg005mxp1dy";

  subPackages = [ "." "cmd/dcrctl" "cmd/promptsecret" ];

  meta = {
    homepage = "https://decred.org";
    description = "Decred daemon in Go (golang)";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ juaningan ];
  };
}
