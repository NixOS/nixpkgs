{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ipget";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipget";
    rev = "v${version}";
    hash = "sha256-5nddlFaQCGJzzH39DqqBNtdc8IFNSLfDv7yKgA4dR6Y=";
  };

  vendorHash = "sha256-miwOJcaSfa4eUIwAt+ewMELzS3Ib023pzFunVSoyBkM=";

  postPatch = ''
    # main module (github.com/ipfs/ipget) does not contain package github.com/ipfs/ipget/sharness/dependencies
    rm -r sharness/dependencies/
  '';

  doCheck = false;

  meta = with lib; {
    description = "Retrieve files over IPFS and save them locally";
    homepage = "https://ipfs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi ];
    mainProgram = "ipget";
  };
}
