{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "cloudflare-ddns";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "favonia";
    repo = "cloudflare-ddns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/806eUsuWhiCnvO1DasPW2xVFYYxnmki3KIDre7gjrg=";
  };

  vendorHash = "sha256-XIfPL1BNA8mcQH+w4AhThh80gh/1vUjKDtFN97O5zqw=";

  subPackages = [
    "cmd/ddns"
  ];

  meta = with lib; {
    description = "Dynamic DNS (DDNS) client for Cloudflare";
    longDescription = ''
      A feature-rich and robust Cloudflare DDNS updater with a small footprint.
      The program will detect your machine’s public IP addresses and update DNS records using the Cloudflare API.
    '';
    homepage = "https://github.com/favonia/cloudflare-ddns";
    mainProgram = "ddns";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix ++ platforms.darwin;
  };
})
