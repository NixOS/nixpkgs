{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation {
  pname = "lha";
  version = "1.14i-unstable-2024-11-27";

  src = fetchFromGitHub {
    owner = "jca02266";
    repo = "lha";
    rev = "26b71be85a762098bdeb95f4533045c7dad86f31";
    hash = "sha256-jiYTBqDXvxTdrvHYaK+1eo4xIpl+B9ZljhBBYD0BGzQ=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "Archiver and compressor using the LZSS and Huffman encoding compression algorithms";
    homepage = "https://github.com/jca02266/lha";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      sander
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
