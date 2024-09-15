{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ipget";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipget";
    rev = "v${version}";
    hash = "sha256-nT0bMy4L1T2rwE6g3Q4tNkmeP3XyPVxCV9yoGqMZjNs=";
  };

  vendorHash = "sha256-q8uwijh3y4l4ebFc3u5Z6TLUUiQqUK6Qpqq/m0kLF14=";

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
