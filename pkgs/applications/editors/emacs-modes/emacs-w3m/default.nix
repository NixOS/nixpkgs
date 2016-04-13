{ fetchcvs, stdenv, emacs, w3m, imagemagick, texinfo, autoreconfHook }:

let date = "2013-03-21"; in
stdenv.mkDerivation rec {
  name = "emacs-w3m-cvs${date}";

  # Get the source from CVS because the previous release (1.4.4) is old and
  # doesn't work with GNU Emacs 23.
  src = fetchcvs {
    inherit date;
    cvsRoot = ":pserver:anonymous@cvs.namazu.org:/storage/cvsroot";
    module = "emacs-w3m";
    sha256 = "1lmcj8rf83w13q8q68hh7sa1abc2m6j2zmfska92xdp7hslhdgc5";
  };

  buildInputs = [ emacs w3m texinfo autoreconfHook ];

  # XXX: Should we do the same for xpdf/evince, gv, gs, etc.?
  patchPhase = ''
    sed -i "w3m.el" \
        -e 's|defcustom w3m-command nil|defcustom w3m-command "${w3m}/bin/w3m"|g ;
            s|(w3m-which-command "display")|"${imagemagick}/bin/display"|g'

    sed -i "w3m-image.el" \
        -e 's|(w3m-which-command "convert")|"${imagemagick}/bin/convert"|g ;
            s|(w3m-which-command "identify")|"${imagemagick}/bin/identify"|g'
  '';

  configureFlags = [
    "--with-lispdir=$(out)/share/emacs/site-lisp"
    "--with-icondir=$(out)/share/emacs/site-lisp/images/w3m"
  ];

  postInstall = ''
    cd "$out/share/emacs/site-lisp"
    for i in ChangeLog*
    do
      mv -v "$i" "w3m-$i"
    done
  '';

  meta = {
    description = "Emacs-w3m, a simple Emacs interface to the w3m web browser";

    longDescription = ''
      Emacs/W3 used to be known as the most popular WEB browser on Emacs, but
      it worked so slowly that we wanted a simple and speedy alternative.

      w3m is a pager with WWW capability, developed by Akinori ITO. Although
      it is a pager, it can be used as a text-mode WWW browser. Then we
      developed a simple Emacs interface to w3m.
    '';

    license = stdenv.lib.licenses.gpl2Plus;

    homepage = http://emacs-w3m.namazu.org/;

    maintainers = [ stdenv.lib.maintainers.mornfall ];
  };
}
