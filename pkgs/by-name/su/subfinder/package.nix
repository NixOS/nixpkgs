{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "subfinder";
<<<<<<< HEAD
  version = "2.11.0";
=======
  version = "2.10.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "subfinder";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-kgOI5/EA5ZAH7yColUdKdVoWwqm33qo5D9B8a26b+0w=";
=======
    hash = "sha256-elv3FPJigd7xhJiTv+eutjBUqMzG50H8Agf5DenwvyU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Subdomain discovery tool";
    longDescription = ''
      SubFinder is a subdomain discovery tool that discovers valid
      subdomains for websites. Designed as a passive framework to be
      useful for bug bounties and safe for penetration testing.
    '';
    homepage = "https://github.com/projectdiscovery/subfinder";
    changelog = "https://github.com/projectdiscovery/subfinder/releases/tag/${src.tag}";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fpletz
=======
    license = licenses.mit;
    maintainers = with maintainers; [
      fpletz
      Br1ght0ne
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      Misaka13514
    ];
    mainProgram = "subfinder";
  };
}
