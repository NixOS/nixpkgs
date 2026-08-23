{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "subfinder";
  version = "2.16.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "subfinder";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eBRi33UbaK5vLvt/ag7g0aN4v5rAS6aeNq1cgfr9qsc=";
  };

  vendorHash = "sha256-VAnRGCiqmqEilWGuMtHTQg3hh38inPXJW3ImZrIE1+Y=";

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

  meta = {
    description = "Subdomain discovery tool";
    longDescription = ''
      SubFinder is a subdomain discovery tool that discovers valid
      subdomains for websites. Designed as a passive framework to be
      useful for bug bounties and safe for penetration testing.
    '';
    homepage = "https://github.com/projectdiscovery/subfinder";
    changelog = "https://github.com/projectdiscovery/subfinder/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fpletz
      Misaka13514
    ];
    mainProgram = "subfinder";
  };
})
