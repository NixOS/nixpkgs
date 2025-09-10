{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ipget";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipget";
    rev = "v${version}";
    hash = "sha256-Q9rgbfPAdAulNuDQ1bXM08aK0IEerbsKqjK8aMnBwcM=";
  };

  vendorHash = "sha256-2boqKf/7y/71ThNodUuZXaRHZadx+TU0d6swHHN1VyM=";

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
