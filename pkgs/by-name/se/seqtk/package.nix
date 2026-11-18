{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  libdeflate,
  isa-l,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "seqtk";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "lh3";
    repo = "seqtk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IQYBs3hUlV9fr8F2SL//houKKEq0nFViq9ulOppRMcM=";
  };

  buildInputs = [
    zlib
    libdeflate
    isa-l
  ];

  makeFlags = [
    "CC:=$(CC)"
    "BINDIR=$(out)/bin"
  ];

  hardeningDisable = [ "format" ];

  preInstall = ''
    mkdir -p "$out/bin"
  '';

  meta = {
    description = "Toolkit for processing sequences in FASTA/Q formats";
    mainProgram = "seqtk";
    license = lib.licenses.mit;
    homepage = "https://github.com/lh3/seqtk";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ bwlang ];
  };
})
