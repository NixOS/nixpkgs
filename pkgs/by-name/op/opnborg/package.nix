{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "opnborg";
  version = "0.1.49";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "opnborg";
    rev = "v${version}";
    hash = "sha256-q6TwYTVDDNLc9iRFQT9oFtT6SyF1zlJbQ9JH+SRfiSc=";
  };

  vendorHash = "sha256-REXJryUcu+/AdVx1aK0nJ98Wq/EdhrZqL24kC1wK6mc=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    changelog = "https://github.com/paepckehh/opnborg/releases/tag/v${version}";
    homepage = "https://paepcke.de/opnborg";
    description = "Sefhosted OPNSense Appliance Backup & Configuration Management Portal";
    license = lib.licenses.bsd3;
    mainProgram = "opnborg";
    maintainers = with lib.maintainers; [ paepcke ];
  };
}
