{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cloudflare-ddns";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "favonia";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/806eUsuWhiCnvO1DasPW2xVFYYxnmki3KIDre7gjrg=";
  };

  vendorHash = "sha256-XIfPL1BNA8mcQH+w4AhThh80gh/1vUjKDtFN97O5zqw=";

  subPackages = [
    "cmd/ddns"
  ];

  meta = with lib; {
    description = "A dynamic DNS (DDNS) client for Cloudflare";
    longDescription = ''
      A feature-rich and robust Cloudflare DDNS updater with a small footprint.
      The program will detect your machine’s public IP addresses and update DNS records using the Cloudflare API.
    '';
    homepage = "https://github.com/favonia/cloudflare-ddns";
    license = licenses.asl20;
    maintainers = with maintainers; [ shokerplz ];
    platforms = platforms.unix ++ platforms.darwin;
  };
}
