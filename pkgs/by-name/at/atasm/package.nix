{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "atasm";
  version = "1.30";

  src = fetchFromGitHub {
    owner = "CycoPH";
    repo = "atasm";
    rev = "V${finalAttrs.version}";
    hash = "sha256-NCxXMaBh3ZplsjmrIuuZg9YReKAPqO0XTKY/PUYjdI8=";
  };

  patches = [
    # select flags for compilation
    ./0001-select-flags.diff
  ];

  dontConfigure = true;

  buildInputs = [
    zlib
  ];

  makeFlags = [ "-C src" ];

  installFlags = [
    "DESTDIR=$(out)/bin/"
    "DOCDIR=$(out)/share/doc/${finalAttrs.pname}"
    "MANDIR=$(out)/man/man1"
  ];

  preInstall = ''
    mkdir -p $out/bin
    install -d $out/share/doc/${finalAttrs.pname} $out/man/man1
  '';

  postInstall = ''
    mv docs/* $out/share/doc/${finalAttrs.pname}
  '';

  doCheck = true;
  checkTarget = "test";

  meta = {
    homepage = "https://github.com/CycoPH/atasm";
    description = "Commandline 6502 assembler compatible with Mac/65";
    license = lib.licenses.gpl2Plus;
    changelog = "https://github.com/CycoPH/atasm/releases/tag/V${finalAttrs.version}";
    maintainers = [ ];
    platforms = with lib.platforms; unix;
  };
})
