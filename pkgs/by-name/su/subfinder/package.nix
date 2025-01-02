{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "subfinder";
  version = "2.6.7";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "subfinder";
    rev = "refs/tags/v${version}";
    hash = "sha256-2IO7TyMcKUB2B9agCoIdjybEjr0RLCv+vhXn9e5eL28=";
  };

  vendorHash = "sha256-+JOrephdT0k3onbgA3CKLeF8iLWycybwtJxalC0n0Ys=";

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
