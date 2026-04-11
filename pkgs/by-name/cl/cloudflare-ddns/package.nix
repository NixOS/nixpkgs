{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "cloudflare-ddns";
  version = "1.16.2";

  src = fetchFromGitHub {
    owner = "favonia";
    repo = "cloudflare-ddns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oQNOYGn3BTVN2EI83cIVYKwtT/Fm8Nf2CXnP1oREVQ0=";
  };

  vendorHash = "sha256-JSd5daOIWblugMq7zmeNEdBiX6cMgNyib4SkCus6yJQ=";

  subPackages = [
    "cmd/ddns"
  ];

  meta = {
    description = "Dynamic DNS (DDNS) client for Cloudflare";
    longDescription = ''
      A feature-rich and robust Cloudflare DDNS updater with a small footprint.
      The program will detect your machine’s public IP addresses and update DNS records using the Cloudflare API.
    '';
    homepage = "https://github.com/favonia/cloudflare-ddns";
    mainProgram = "ddns";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ shokerplz ];
    platforms = lib.platforms.unix ++ lib.platforms.darwin;
  };
})
