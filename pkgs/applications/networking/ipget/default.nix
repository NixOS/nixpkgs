{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ipget";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipget";
    rev = "v${version}";
    sha256 = "sha256-YD05HIVr99b8VmEJgzY2ClNv31I98d0NbfCk3XcB+xk=";
  };

  vendorSha256 = "sha256-bymHVWskCt7bf02CveMXl1VhZYhRSEH7xIoESh31iGg=";

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
