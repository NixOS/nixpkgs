{ stdenv, fetchurl, emacs, texinfo }:

stdenv.mkDerivation rec {
  name = "haskell-mode-20141113";

  src = fetchurl {
    url = "https://github.com/haskell/haskell-mode/archive/fa6468ed36166799439ffea454dddf85335bb424.zip";
    sha256 = "0y5nz565dyvwjgm16w2jbknnkhnqn3v0lgp08axmnxd6rbkpm33d";
  };

  buildInputs = [ emacs texinfo ];

  installPhase = ''
    mkdir -p "$out/share/emacs/site-lisp"
    cp *.el *.elc *.hs "$out/share/emacs/site-lisp/"
  '';

  meta = {
    homepage = "http://github.com/haskell/haskell-mode";
    description = "Haskell mode for Emacs";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
