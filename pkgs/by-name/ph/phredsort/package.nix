{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "phredsort";
  version = "1.4.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vmikk";
    repo = "phredsort";
    tag = "${finalAttrs.version}";
    hash = "sha256-kZzEfX+1fBZS5vLV4qfAF5mJh9/ev+I6lRTR2B1dCMc=";
  };

  vendorHash = "sha256-ntOZAr78luezOJftbveq4X4GOr+6DUe3oxE610C5ORs=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "CLI tool for sorting sequences in a FASTQ file by their quality scores";
    homepage = "https://github.com/vmikk/phredsort";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ artur-sannikov ];
  };
})
