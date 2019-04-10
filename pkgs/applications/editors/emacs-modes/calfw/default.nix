{ fetchgit, stdenv, emacs }:

# TODO: byte-compile in build phase - a buildEmacsPackage that does
# that would be nice

stdenv.mkDerivation rec {
  name = "calfw-1.3-5-ga9b6615";

  src = fetchgit {
    url = "git://github.com/kiwanami/emacs-calfw.git";
    rev = "a9b6615b6666bbebe78257c557fd9a2e3a325d8d";
    sha256 = "524acc8fec7e64ebe0d370ddb1d96eee6a409d650b79011fa910c35225a7f393";
  };

  buildInputs = [ emacs ];

  installPhase =
    ''
       mkdir -p "$out/share/doc/${name}"
       cp -v readme.md "$out/share/doc/${name}"

       mkdir -p "$out/share/emacs/site-lisp/"
       cp *.el "$out/share/emacs/site-lisp/"
    '';

  meta = {
    description = "A calendar framework for Emacs";

    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = stdenv.lib.platforms.unix;
  };
}
