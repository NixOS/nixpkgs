{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "subfinder";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "subfinder";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AqXTK+1mK5EmK/6T2+VIDD8jYzafMUEduJ/gLTqaYv8=";
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
