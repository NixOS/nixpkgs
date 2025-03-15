{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:
buildGoModule rec {
  pname = "dns-over-https";
  version = "2.3.8";

  src = fetchFromGitHub {
    owner = "m13253";
    repo = "dns-over-https";
    tag = "v${version}";
    hash = "sha256-0tjqj67PWPRChspUQQeZqtW68IB2G8N2vhebMwHNbX4=";
  };

  vendorHash = "sha256-cASJYEglq2IrnxjqOCiepjExX/FmakeMjxPOsjUDTWM=";

  ldflags = [
    "-w"
    "-s"
  ];

  subPackages = [
    "doh-client"
    "doh-server"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/m13253/dns-over-https";
    changelog = "https://github.com/m13253/dns-over-https/releases/tag/v${version}";
    description = "High performance DNS over HTTPS client & server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cryo ];
    platforms = lib.platforms.all;
  };
}
