{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "atasm";
  version = "1.30";

  src = fetchFromGitHub {
    owner = "CycoPH";
    repo = "atasm";
    rev = "V${version}";
    hash = "sha256-NCxXMaBh3ZplsjmrIuuZg9YReKAPqO0XTKY/PUYjdI8=";
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

  preBuild = ''
    makeFlagsArray+=(
      -C ./src
      CC=cc
      USEZ="-DZLIB_CAPABLE -I${zlib}/include"
      ZLIB="-L${zlib}/lib -lz"
      UNIX="-DUNIX"
    )
  '';

  preInstall = ''
    mkdir -p $out/bin/
    install -d $out/share/doc/${pname} $out/man/man1
    installFlagsArray+=(
      DESTDIR=$out/bin/
      DOCDIR=$out/share/doc/${pname}
      MANDIR=$out/man/man1
    )
  '';

  postInstall = ''
    mv docs/* $out/share/doc/${pname}
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    make "''${makeFlagsArray[@]}" test

    runHook postCheck
  '';

  meta = {
    homepage = "https://github.com/CycoPH/atasm";
    description = "Commandline 6502 assembler compatible with Mac/65";
    license = lib.licenses.gpl2Plus;
    changelog = "https://github.com/CycoPH/atasm/releases/tag/V${version}";
    maintainers = [ ];
    platforms = with lib.platforms; unix;
  };
}
