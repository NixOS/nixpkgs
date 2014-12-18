{ stdenv, fetchFromGitHub, emacs, texinfo }:

stdenv.mkDerivation rec {
  name = "haskell-mode-20141113";

  src = fetchFromGitHub {
    owner = "haskell";    
    repo = "haskell-mode";
    rev = "fa6468ed36166799439ffea454dddf85335bb424";
    sha256 = "12qvlcbil25fs1amndpy03pfqlsbidav9rd1fc79whqxrgylxxnz";
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
