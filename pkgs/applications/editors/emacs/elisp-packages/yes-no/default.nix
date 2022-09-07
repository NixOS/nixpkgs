{ lib, stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "yes-no";

  src = fetchurl {
    url = "https://github.com/emacsmirror/emacswiki.org/blob/185fdc34fb1e02b43759ad933d3ee5646b0e78f8/yes-no.el";
    sha256 = "1k0nn619i82jiqm48k5nk6b8cv2rggh0i5075nhc85a2s9pwhx32";
  };

  dontUnpack = true;

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install $src $out/share/emacs/site-lisp/yes-no.el
  '';

  meta = with lib; {
    description = "Specify use of `y-or-n-p' or `yes-or-no-p' on a case-by-case basis";
    homepage = "https://www.emacswiki.org/emacs/yes-no.el";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jcs090218 ];
    platforms = platforms.all;
  };
}
