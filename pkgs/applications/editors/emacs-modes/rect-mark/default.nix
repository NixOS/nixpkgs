{stdenv, fetchurl, emacs}:

stdenv.mkDerivation rec {
  name = "rect-mark-1.4";

  src = fetchurl {
    url = "http://emacswiki.org/emacs/download/rect-mark.el";
    sha256 = "0pyyg53z9irh5jdfvh2qp4pm8qrml9r7lh42wfmdw6c7f56qryh8";
  };

  phases = [ "buildPhase" "installPhase"];

  buildInputs = [ emacs ];

  buildPhase = ''
    cp $src rect-mark.el
    emacs --batch -f batch-byte-compile rect-mark.el
  '';

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install rect-mark.el* $out/share/emacs/site-lisp
  '';

  meta = {
    description = "Mark a rectangle of text with highlighting";
    homepage = http://emacswiki.org/emacs/RectangleMark;
    license = stdenv.lib.licenses.gpl2Plus;

    platforms = stdenv.lib.platforms.all;
  };
}
