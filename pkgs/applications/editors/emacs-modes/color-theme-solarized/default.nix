{stdenv, fetchzip, emacs, colorTheme}:
let
  commit = "412713a0fcedd520d208a7b783fea03d710bcc61";
in
stdenv.mkDerivation rec {
  name = "color-theme-solarized-1.0.0";

  src = fetchzip {

    url = "https://github.com/sellout/emacs-color-theme-solarized/archive/${commit}.zip";
    sha256 = "1xd2yk7p39zxgcf91s80pqknzdxw9d09cppjb87g7ihj6f0wxqjv";
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

  meta = with stdenv.lib; {
    description = "Precision colors for machines and people";
    homepage = http://ethanschoonover.com/solarized;
    maintainers = [ maintainers.samuelrivas ];
    license = licenses.mit;
    platforms = platforms.all;

    # Fails with `solarized-definitions.el:786:1:Warning: the function `rotatef' is not known to`
    broken = true;
  };
}
