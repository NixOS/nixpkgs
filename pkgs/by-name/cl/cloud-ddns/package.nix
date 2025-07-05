{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "cloud-ddns";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "jason-m";
    repo = "cloud-ddns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4JGSWaEHeFRHBkGBOEefsdiLgql4zff1lZvzMsc8xg0=";
  };

  vendorHash = "sha256-gD766ZPFJ9km3udSAB8TtmDk/J8OMd0863bvHqalMFo=";

  meta = {
    description = "Dynamic DNS bridge converting DynDNS requests to cloud DNS API calls";
    longDescription = ''
      This is a Go application that acts as a Dynamic DNS (DDNS) bridge,
      converting DynDNS-formatted HTTP requests into API calls for cloud DNS services.
      Supports AWS Route53, Cloudflare, Azure DNS, and DigitalOcean.
    '';
    homepage = "https://github.com/jason-m/cloud-ddns";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ jason-m ];
    platforms = lib.platforms.unix;
    mainProgram = "cloud-ddns";
  };
})
