{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:
buildGoModule rec {
  pname = "dns-over-https";
  version = "2.3.7";

  src = fetchFromGitHub {
    owner = "m13253";
    repo = "dns-over-https";
    tag = "v${version}";
    hash = "sha256-3mg4kDlIqv+psQU/FxA9TksGVAYaOymEDpAhMBZuqKI=";
  };

  vendorHash = "sha256-Dun1HWjV44PTpnijWBpGXqmKxtUw+Qu8rqsyMhEpkb4=";

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
