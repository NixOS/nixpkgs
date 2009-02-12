{ fetchurl, stdenv, emacs, eieio }:

stdenv.mkDerivation rec {
  name = "semantic-1.4.4";

  src = fetchurl {
    url = "mirror://sourceforge/cedet/${name}.tar.gz";
    sha256 = "0j50dqdy5bl35vqfbgxp93grs11llg9i4398044br73lvvif9n5f";
  };

  buildInputs = [ emacs eieio ];

  doCheck = true;
  checkPhase = "make Tests";

  preConfigure = ''
    sed -i "Makefile" -es'|^LOADPATH[[:blank:]]*=.*$|LOADPATH = ${eieio}/share/emacs/site-lisp|g'
  '';

  installPhase = ''
    ensureDir "$out/share/emacs/site-lisp"
    cp -v *.el *.elc "$out/share/emacs/site-lisp"
    chmod a-x "$out/share/emacs/site-lisp/"*

    ensureDir "$out/share/info"
    cp -v *.info* "$out/share/info"
  '';

  meta = {
    description = "Semantic, infrastructure for parser based text analysis in Emacs";

    longDescription = ''
      Semantic is an infrastructure for parser based text analysis in
      Emacs.  It is a lexer, parser-generator, and parser.  It is
      written in Emacs Lisp and is customized to the way Emacs thinks
      about language files, and is optimized to use Emacs' parsing
      capabilities.

      Semantic's goal is to provide an intermediate API for authors of
      language agnostic tools who want to deal with languages in a
      generic way.  It also provides a simple way for Mode Authors who
      are experts in their language, to provide a parser for those
      tool authors, without knowing anything about those tools.
    '';

    license = "GPLv2+";

    homepage = http://cedet.sourceforge.net/;
  };
}
