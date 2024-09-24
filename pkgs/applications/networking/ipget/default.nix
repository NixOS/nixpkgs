{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ipget";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipget";
    rev = "v${version}";
    hash = "sha256-SCYbfsQ8yF2ggwNyW0+kydpSBQN9NPpz1Hmw4ni3cg0=";
  };

  vendorHash = "sha256-90iimOtFys12nrT0hHyzHrpB03YGNfHY/a7V8Blijfw=";

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
