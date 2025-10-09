{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "der-ascii";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "der-ascii";
    rev = "v${version}";
    sha256 = "sha256-xGzxq5AHvzLUOp9VUcI9JMwrCpVIrpDvenWUOEBP6pA=";
  };
  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = ''
      Small human-editable language to emit DER or BER encodings of ASN.1
      structures and malformed variants of them
    '';
    homepage = "https://github.com/google/der-ascii";
    license = licenses.asl20;
    maintainers = with maintainers; [
      alexshpilkin
      cpu
      hawkw
    ];
    mainProgram = "ascii2der"; # has stable output, unlike its inverse
  };
}
