{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "seqhasher";
  version = "1.2.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vmikk";
    repo = "seqhasher";
    tag = "${finalAttrs.version}";
    hash = "sha256-zMMEfA8akh1i1518AkJcd/BIdS7/vRfHjmKTkvVFfDg=";
  };

  vendorHash = "sha256-Ix3mIwVw4KcD1rKdOiHxfiuk82okJZom2gy6E88DyKI=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool for hashing individual sequences in FASTA/FASTQ files";
    homepage = "https://github.com/vmikk/seqhasher";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ artur-sannikov ];
  };
})
