{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ipget";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipget";
    rev = "v${version}";
    hash = "sha256-gcxfsP5awCCau1RqCuXKEdXC2jvpwsGsPkBsiaRlfBU=";
  };

  vendorHash = "sha256-qCUa/XbfDrbwPSZywNVK/yn88C7Dsmz0cDTG2Z4ho0Y=";

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
  };
}
