{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
}:

stdenv.mkDerivation {
  pname = "pgn-extract";
  version = "25-01";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchzip {
    url = "https://www.cs.kent.ac.uk/~djb/pgn-extract/pgn-extract-25-01.tgz";
    hash = "sha256-SHteE0wpuS2JxrS9KvkIxe4krGzRnQVBD4dQgabFLlU=";
    stripRoot = false;
  };

  sourceRoot = "source/pgn-extract";

  # Makefile hardcodes CC=gcc which fails on Darwin (uses clang)
  # Override to use stdenv's compiler (gcc on Linux, clang on Darwin)
  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    runHook preInstall

    install -D pgn-extract $out/bin/pgn-extract
    install -D eco.pgn $out/share/eco.pgn
    install -D pgn-extract.man $out/share/man/man1/pgn-extract.1

    runHook postInstall
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    make --directory=test PGN_EXTRACT=../pgn-extract ECO_FILE=../eco.pgn

    runHook postCheck
  '';

  postInstall = ''
    wrapProgram $out/bin/pgn-extract \
      --set ECO_FILE $out/share/eco.pgn
  '';

  meta = {
    description = "Portable Game Notation (PGN) Manipulator for Chess Games";
    homepage = "https://www.cs.kent.ac.uk/~djb/pgn-extract/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ daniel-fahey ];
    platforms = lib.platforms.unix;
  };
}
