{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wgcf";
  version = "2.2.19";

  src = fetchFromGitHub {
    owner = "ViRb3";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-wEBPaqqpiQdFohlzpVDVMwYq8+NjSQrh58yWl/W+n8M=";
  };

  subPackages = ".";

  vendorHash = "sha256-i1CM0rG2DmgYMa+Na0In4fVJSGZlMTRajjLEZUvrmE8=";

  meta = with lib; {
    description = "Cross-platform, unofficial CLI for Cloudflare Warp";
    homepage = "https://github.com/ViRb3/wgcf";
    license = licenses.mit;
    maintainers = with maintainers; [ yureien ];
  };
}
