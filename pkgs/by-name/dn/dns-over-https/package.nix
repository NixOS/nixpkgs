{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:
buildGoModule rec {
  pname = "dns-over-https";
  version = "2.3.10";

  src = fetchFromGitHub {
    owner = "m13253";
    repo = "dns-over-https";
    tag = "v${version}";
    hash = "sha256-WQ6OyZfQMtW9nZcvlBjHk0R96NQr0Lc2mGB5taC0d6k=";
  };

  vendorHash = "sha256-46BrN50G5IhdMwMVMU9Wdj/RFzUzIPoTRucCedMGu4g=";

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
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
