{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  testers,
  lha,
}:

stdenv.mkDerivation {
  pname = "lha";
  version = "1.14i-unstable-2026-01-01";

  src = fetchFromGitHub {
    owner = "jca02266";
    repo = "lha";
    rev = "86094cb56aba34de45668f39f74fcfb61e9d7fb6";
    hash = "sha256-ckzcCvt5v6rBcp9n8XXzgS2XkURbO8bsqTURGLRzpAU=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  passthru.tests.version = testers.testVersion {
    package = lha;
    command = "lha --help";
    version = "1.14i";
  };

  meta = {
    description = "Archiver and compressor using the LZSS and Huffman encoding compression algorithms";
    homepage = "https://github.com/jca02266/lha";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      momeemt
    ];
    # Some of the original LHa code has been rewritten and the current author
    # considers adopting a "true" free and open source license for it.
    # However, old code is still covered by the original LHa license, which is
    # not a free software license (it has additional requirements on commercial
    # use).
    license = lib.licenses.unfree;
    mainProgram = "lha";
  };
}
