{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation {
  pname = "qdb";
  version = "1.2";

  src = fetchurl {
    url = "https://brainfuck.org/qdb.c";
    hash = "sha256-5GPsZ2F7bNxoCzWGbh2Xg/H+e3IcsVpQ1UtSD3yHTMw=";
  };
  unpackPhase = "cp $src qdb.c";

  buildPhase = ''
    cc qdb.c -o qdb
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp qdb $out/bin/
  '';

  meta = {
    description = "Quick and dirty brainfuck interpreter";
    mainProgram = "qdb";
    homepage = "https://brainfuck.org/qdb.c";

    # Make any use you like of this software. I can't stop you anyway. :)
    license = lib.licenses.publicDomain;
  };
}
