{ stdenv, fetchurl, emacs }:

stdenv.mkDerivation rec {
  name = "auto-complete-1.3.1";

  src = fetchurl {
    url = "http://cx4a.org/pub/auto-complete/${name}.tar.bz2";
    sha256 = "124qxfp0pcphwlmrasbfrci48brxnrzc38h4wcf2sn20x1mvcrlj";
  };

  buildInputs = [ emacs ];

  preInstall = ''
    install -d $out/share/emacs/site-lisp
  '';

  installFlags = "DIR=$(out)/share/emacs/site-lisp";

  postInstall = ''
    ln -s javascript-mode $out/share/emacs/site-lisp/ac-dict/js2-mode
  '';

  meta = {
    description = "Auto-complete extension for Emacs";
    homepage = http://cx4a.org/software/auto-complete/;
    license = stdenv.lib.licenses.gpl3Plus;

    platforms = stdenv.lib.platforms.all;
  };
}
