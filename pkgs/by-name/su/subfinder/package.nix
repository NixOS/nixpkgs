{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "subfinder";
  version = "2.6.8";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "subfinder";
    tag = "v${version}";
    hash = "sha256-xKK34SDjajLngmYsHADqof+/Hma2WuDj4SFkcqqm3hs=";
  };

  vendorHash = "sha256-jVLkClwjK7Uvj8ZxOpAACafftwpBNHipQetF2FSpbYY=";

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
