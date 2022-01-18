{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ipget";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipget";
    rev = "v${version}";
    sha256 = "sha256-qRPke8/CUmGX6v+8qv9JQCUC8T9pjwRRyGmBWvatsJ0=";
  };

  vendorSha256 = "sha256-La9V5B+UDaOswh/R8ad4xsnCF5ewtF7G+uiqnarM4Mg=";

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
