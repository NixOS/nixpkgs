{
  stdenv,
  cedille,
  emacs,
}:

stdenv.mkDerivation {
  pname = "cedille-mode";

  inherit (cedille) version src;

  buildInputs = [ emacs ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -d $out/share/emacs/site-lisp
    install se-mode/*.el se-mode/*.elc $out/share/emacs/site-lisp
    install cedille-mode/*.el cedille-mode/*.elc $out/share/emacs/site-lisp
    install *.el *.elc $out/share/emacs/site-lisp
    substituteInPlace $out/share/emacs/site-lisp/cedille-mode.el \
      --replace /usr/bin/cedille ${cedille}/bin/cedille

    runHook postInstall
  '';

  meta = {
    inherit (cedille.meta)
      homepage
      license
      maintainers
      platforms
      ;
    description = "Emacs major mode for Cedille";
  };
}
