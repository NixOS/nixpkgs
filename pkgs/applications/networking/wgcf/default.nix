{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wgcf";
  version = "2.2.14";

  src = fetchFromGitHub {
    owner = "ViRb3";
    repo  = pname;
    rev   = "v${version}";
    hash  = "sha256-6V4fIoFB0fuCEu1Rj8QWGDNdgystrD/gefjbshvxVsw=";
  };

  subPackages = ".";

  vendorSha256 = "sha256-NGlV/qcnUlNLvt3uVRdfx+lUDgqAEBEowW9WIHBY+AI=";

  meta = with lib; {
    description = "Cross-platform, unofficial CLI for Cloudflare Warp";
    homepage    = "https://github.com/ViRb3/wgcf";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ yureien ];
  };
}
