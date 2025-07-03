{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cloud-ddns";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "jason-m";
    repo = pname;
    rev = "70b82c9";
    sha256 = "sha256-4JGSWaEHeFRHBkGBOEefsdiLgql4zff1lZvzMsc8xg0=";
  };

  vendorHash = "sha256-gD766ZPFJ9km3udSAB8TtmDk/J8OMd0863bvHqalMFo=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Dynamic DNS bridge converting DynDNS requests to cloud DNS API calls";
    longDescription = ''
      This is a Go application that acts as a Dynamic DNS (DDNS) bridge,
      converting DynDNS-formatted HTTP requests into API calls for cloud DNS services.
      Supports AWS Route53, Cloudflare, Azure DNS, and DigitalOcean.
    '';
    homepage = "https://github.com/jason-m/cloud-ddns";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jason-m ];
    platforms = platforms.unix;
    mainProgram = "cloud-ddns";
  };
}
