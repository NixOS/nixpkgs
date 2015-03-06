{ stdenv, fetchgit, emacs, bbdb }:

stdenv.mkDerivation rec {
  name = "bbdb-vcard-export-1e16c";

  src = fetchgit {
    url = "https://github.com/emacsmirror/bbdb-vcard-export.git";
    rev = "1e16ccbc1d070eac861886ef4b5a5643ec24fe74";
    sha256 = "1z6kn54gzx43wjv5vsm4bqd2zn86w5zxy59j2nqrgfi5wfz5pnd1";
  };

  buildInputs = [ emacs bbdb ];

  buildPhase = ''
    emacs -L "${bbdb}/share/emacs/site-lisp" --batch \
      -f batch-byte-compile *.el
  '';

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install *.el *.elc $out/share/emacs/site-lisp
  '';

  meta = {
    description = "Export BBDB as vCard files";
    homepage = http://www.emacswiki.org/emacs/bbdb-vcard-export.el;
    license = stdenv.lib.licenses.gpl2Plus;

    platforms = stdenv.lib.platforms.all;
  };
}
