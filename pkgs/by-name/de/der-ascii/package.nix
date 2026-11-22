{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "der-ascii";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "der-ascii";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-I15y7d+nVt6VAdjqvNbMp06OjfAxoG4WLvNumhvPZ1o=";
  };
  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = ''
      Small human-editable language to emit DER or BER encodings of ASN.1
      structures and malformed variants of them
    '';
    homepage = "https://github.com/google/der-ascii";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      alexshpilkin
      cpu
      hawkw
    ];
    mainProgram = "ascii2der"; # has stable output, unlike its inverse
  };
})
