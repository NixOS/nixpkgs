{ fetchurl, stdenv, emacs, w3m, texinfo }:

stdenv.mkDerivation rec {
  name = "emacs-w3m-1.4.4";

  src = fetchurl {
    url = "http://emacs-w3m.namazu.org/${name}.tar.gz";
    sha256 = "193p3kkjk1glhlgfqb9hz99av2i4b53civkz23ayvz3w9wvyird3";
  };

  buildInputs = [ emacs w3m texinfo ];

  patchPhase = ''
    sed -i "w3m.el" \
        -e 's|defcustom w3m-command nil|defcustom w3m-command "${w3m}/bin/w3m"|g'
  '';

  configurePhase = ''
    ./configure --prefix="$out" --with-lispdir="$out/share/emacs/site-lisp" \
                --with-icondir="$out/share/emacs/site-lisp/images/w3m"
  '';

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

    license = "GPLv2+";

    homepage = http://emacs-w3m.namazu.org/;

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
