{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "atasm";
  version = "1.32";

  src = fetchFromGitHub {
    owner = "CycoPH";
    repo = "atasm";
    tag = "V${finalAttrs.version}";
    hash = "sha256-PaMnBKdQJ6NuzgWrjSUyWUV8x6z7Ymmqv5fjDXxfLV0=";
  };

  makefile = "Makefile";

  patches = [
    # select flags for compilation
    ./0001-select-flags.diff
  ];

  dontConfigure = true;

  buildInputs = [
    zlib
  ];

  strictDeps = true;

  makeFlags = [
    "--directory=./src"
    "CC=cc"
    "USEZ=-DZLIB_CAPABLE -I${zlib}/include"
    "ZLIB=-L${zlib}/lib -lz"
    "UNIX=-DUNIX"
  ];

  installFlags = [
    "DESTDIR=$(out)/bin/"
    "DOCDIR=$(out)/share/doc/atasm"
    "MANDIR=$(out)/man/man1"
  ];

  preInstall = ''
    mkdir -p $out/bin/
    install -d $out/share/doc/atasm $out/man/man1
  '';

  postInstall = ''
    mv docs/* $out/share/doc/atasm
  '';

  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/CycoPH/atasm";
    description = "Commandline 6502 assembler compatible with Mac/65";
    license = lib.licenses.gpl2Plus;
    changelog = "https://github.com/CycoPH/atasm/releases/tag/V${finalAttrs.version}";
    maintainers = [ ];
    platforms = with lib.platforms; unix;
    mainProgram = "atasm";
  };
})
