{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

buildGoModule rec {
  pname = "ipget";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipget";
    rev = "v${version}";
    hash = "sha256-a+dVqIo+cmEnYrc1A98/APJq0m2pSKC5HKIN04rfziY=";
  };

  vendorHash = "sha256-tYBM0NGHhLNTRfsv+UgBmtpxItjPIr7Klo708vaXItw=";

  postPatch = ''
    # main module (github.com/ipfs/ipget) does not contain package github.com/ipfs/ipget/sharness/dependencies
    rm -r sharness/dependencies/
  '';

  doCheck = false;

  passthru.tests = {
    inherit (nixosTests) ipget;
  };

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Retrieve files over IPFS and save them locally";
    homepage = "https://ipfs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi ];
    mainProgram = "ipget";
  };
}
