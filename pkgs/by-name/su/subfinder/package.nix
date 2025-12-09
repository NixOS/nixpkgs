{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "subfinder";
  version = "2.10.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "subfinder";
    tag = "v${version}";
    hash = "sha256-elv3FPJigd7xhJiTv+eutjBUqMzG50H8Agf5DenwvyU=";
  };

  vendorHash = "sha256-ss1lcdqBni5SmHVLDQpFFVTQ3/nL8qPTl5zul1GQpBM=";

  patches = [
    # Disable automatic version check
    ./disable-update-check.patch
  ];

  subPackages = [
    "cmd/subfinder/"
  ];

  ldflags = [
    "-w"
    "-s"
  ];

  meta = with lib; {
    description = "Subdomain discovery tool";
    longDescription = ''
      SubFinder is a subdomain discovery tool that discovers valid
      subdomains for websites. Designed as a passive framework to be
      useful for bug bounties and safe for penetration testing.
    '';
    homepage = "https://github.com/projectdiscovery/subfinder";
    changelog = "https://github.com/projectdiscovery/subfinder/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [
      fpletz
      Misaka13514
    ];
    mainProgram = "subfinder";
  };
}
