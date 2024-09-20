{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "der-ascii";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lCA2p9O4ijpDPJZhiGIYhfM3JeU9zgiosNFpHfa2MoY=";
  };
  vendorHash = null;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = ''
      A small human-editable language to emit DER or BER encodings of ASN.1
      structures and malformed variants of them
    '';
    homepage = "https://github.com/google/der-ascii";
    license = licenses.asl20;
    maintainers = with maintainers; [ alexshpilkin cpu hawkw ];
    mainProgram = "ascii2der"; # has stable output, unlike its inverse
  };
}
