{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wgcf";
<<<<<<< HEAD
  version = "2.2.19";

  src = fetchFromGitHub {
    owner = "ViRb3";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-wEBPaqqpiQdFohlzpVDVMwYq8+NjSQrh58yWl/W+n8M=";
=======
  version = "2.2.14";

  src = fetchFromGitHub {
    owner = "ViRb3";
    repo  = pname;
    rev   = "v${version}";
    hash  = "sha256-6V4fIoFB0fuCEu1Rj8QWGDNdgystrD/gefjbshvxVsw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  subPackages = ".";

<<<<<<< HEAD
  vendorHash = "sha256-i1CM0rG2DmgYMa+Na0In4fVJSGZlMTRajjLEZUvrmE8=";

  meta = with lib; {
    description = "Cross-platform, unofficial CLI for Cloudflare Warp";
    homepage = "https://github.com/ViRb3/wgcf";
    license = licenses.mit;
=======
  vendorSha256 = "sha256-NGlV/qcnUlNLvt3uVRdfx+lUDgqAEBEowW9WIHBY+AI=";

  meta = with lib; {
    description = "Cross-platform, unofficial CLI for Cloudflare Warp";
    homepage    = "https://github.com/ViRb3/wgcf";
    license     = licenses.mit;
    platforms   = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ yureien ];
  };
}
