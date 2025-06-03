{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "subfinder";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "subfinder";
    tag = "v${version}";
    hash = "sha256-pbrW95CrRRQok6MfA0ujjLiXTr1VFUswc/gK9WhU6qI=";
  };

  vendorHash = "sha256-v+AyeQoeTTPI7C1WysCu8adX6cBk06JudPigCIWNFGQ=";

  modRoot = "./v2";

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
    license = licenses.mit;
    maintainers = with maintainers; [
      fpletz
      Br1ght0ne
      Misaka13514
    ];
    mainProgram = "subfinder";
  };
}
