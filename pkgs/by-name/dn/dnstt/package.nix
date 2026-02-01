{
  lib,
  buildGoModule,
  fetchgit,
}:
buildGoModule {
  pname = "dnstt";
  version = "0-unstable-2026-01-25";
  src = fetchgit {
    url = "https://www.bamsoftware.com/git/dnstt.git";
    rev = "e5e873bd64d9e3edefb8978175572730494f89a8";
    hash = "sha256-PrRbPRn9sthuM3Rmo8QDX1WBaiLMTsl/05uKh8oYlEc=";
  };
  vendorHash = "sha256-fWH2pwLRDemFZP3yqxG15YpvdtyIjJvpmLckhaloMvA=";

  subPackages = [
    "dnstt-server"
    "dnstt-client"
  ];

  meta = {
    description = "A DNS tunnel that can use DNS over HTTPS (DoH) and DNS over TLS (DoT) resolvers";
    homepage = "https://www.bamsoftware.com/software/dnstt";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ nix-julia ];
    platforms = lib.platforms.linux;
  };
}
