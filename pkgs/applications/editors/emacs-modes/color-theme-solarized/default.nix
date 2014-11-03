{stdenv, fetchgit, emacs, colorTheme}:

stdenv.mkDerivation rec {
  name = "color-theme-6.5.5";

  src = fetchgit {
    url = https://github.com/sellout/emacs-color-theme-solarized.git;
    rev = "6a2c7ca0181585858e6e8054cb99db837e2ef72f";
    sha256 = "3c46a3d66c75ec4456209eeafdb03282148b289b12e8474f6a8962f3894796e8";
  };

  buildInputs = [ emacs ];
  propagatedUserEnvPkgs = [ colorTheme ];


  buildPhase = ''
    emacs -L . -L ${colorTheme}/share/emacs/site-lisp --batch -f batch-byte-compile *.el
  '';

  installPhase = ''
    mkdir -p $out/share/emacs/site-lisp
    install *.el* $out/share/emacs/site-lisp
  '';

  meta = {
    description = "Precision colors for machines and people";
    homepage = http://ethanschoonover.com/solarized;
    license = stdenv.lib.licenses.mit;

    platforms = stdenv.lib.platforms.all;
  };
}
