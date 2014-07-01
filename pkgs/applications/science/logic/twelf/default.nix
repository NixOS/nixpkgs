{ stdenv, fetchurl, pkgconfig, smlnj, rsync }:

stdenv.mkDerivation rec {
  name = "twelf-${version}";
  version = "1.7.1";

  src = fetchurl {
    url = "http://twelf.plparty.org/releases/twelf-src-${version}.tar.gz";
    sha256 = "0fi1kbs9hrdrm1x4k13angpjasxlyd1gc3ys8ah54i75qbcd9c4i";
  };

  buildInputs = [ pkgconfig smlnj rsync ];

  buildPhase = ''
    export SMLNJ_HOME=${smlnj}
    make smlnj
  '';

  installPhase = ''
    ensureDir $out/bin
    rsync -av bin/* $out/bin/

    ensureDir $out/share/emacs/site-lisp/twelf/
    rsync -av emacs/ $out/share/emacs/site-lisp/twelf/

    ensureDir $out/share/twelf/examples
    rsync -av examples/ $out/share/twelf/examples/
    ensureDir $out/share/twelf/vim
    rsync -av vim/ $out/share/twelf/vim/
  '';

  meta = {
    description = "Twelf logic proof assistant";
    longDescription = ''
      Twelf is a language used to specify, implement, and prove properties of
      deductive systems such as programming languages and logics. Large
      research projects using Twelf include the TALT typed assembly language,
      a foundational proof-carrying-code system, and a type safety proof for
      Standard ML.
    '';
    homepage = http://twelf.org/wiki/Main_Page;
    license = "MIT";
    maintainers = with stdenv.lib.maintainers; [ jwiegley ];
    platforms = stdenv.lib.platforms.unix;
  };
}
