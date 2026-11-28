{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "dns-over-https";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "m13253";
    repo = "dns-over-https";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Nmk3exLzWNRdyEt/Bx4qxoToLwf4X6YABSGEWsCpsu8=";
  };

  vendorHash = "sha256-5BFU3EBcFwyiLe6Wq49BDS/CFshLXIruAiDMWCa4sn0=";

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
    changelog = "https://github.com/m13253/dns-over-https/releases/tag/v${finalAttrs.version}";
    description = "High performance DNS over HTTPS client & server";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
