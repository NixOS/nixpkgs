{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ipget";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipget";
    rev = "v${version}";
    sha256 = "sha256-JGG3DsmFXmWFOFvJ8pKVhQMRgZ0cbkdtmBjMkLYqOwU=";
  };

  vendorSha256 = "sha256-scrueQoqr9nUONnpitUontcX3Xe0KmmUmvxOcpxK7M8=";

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
    platforms = platforms.unix;
  };
}
