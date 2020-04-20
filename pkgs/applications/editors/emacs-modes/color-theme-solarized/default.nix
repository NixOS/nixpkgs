{stdenv, fetchzip, emacs, color-theme}:
let
  commit = "f3ca8902ea056fb8e46cb09f09c96294e31cd4ee";
in
stdenv.mkDerivation {
  name = "color-theme-solarized-1.0.0";

  src = fetchzip {

    url = "https://github.com/sellout/emacs-color-theme-solarized/archive/${commit}.zip";
    sha256 = "16d7adqi07lzzr0qipl1fbag9l8kiyr3xrqxi528pimcisbg85d3";
  };

  buildInputs = [ emacs ];
  propagatedUserEnvPkgs = [ color-theme ];

  buildPhase = ''
    emacs -L . -L ${color-theme}/share/emacs/site-lisp/elpa/color-theme-* --batch -f batch-byte-compile *.el
  '';

  installPhase = ''
    mkdir -p $out/share/emacs/site-lisp
    install *.el* $out/share/emacs/site-lisp
  '';

  meta = with stdenv.lib; {
    description = "Precision colors for machines and people";
    homepage = "http://ethanschoonover.com/solarized";
    maintainers = [ maintainers.samuelrivas ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
