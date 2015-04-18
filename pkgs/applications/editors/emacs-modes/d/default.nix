{stdenv, fetchurl, emacs}:

# Note: Don't have a version, using date as fallback.
let version = "20150111";

in stdenv.mkDerivation {
  name = "emacs-d-${version}";

  src = fetchurl {
    url = "https://github.com/Emacs-D-Mode-Maintainers/Emacs-D-Mode/archive/53efec4d83c7cee8227597f010fe7fc400ff05f1.tar.gz";
    sha256 = "0vb0za51lc6qf1qgqisap4vzk36caa5k17zajjn034rhjsqfw0w7";
  };

  buildInputs = [ emacs ];

  buildPhase = ''
    emacs -L . --batch -f batch-byte-compile *.el
  '';

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install *.el *.elc $out/share/emacs/site-lisp
  '';

  meta = {
    description = "Major mode for editing D code";
    homepage = https://github.com/Emacs-D-Mode-Maintainers/Emacs-D-Mode;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
  };

}
