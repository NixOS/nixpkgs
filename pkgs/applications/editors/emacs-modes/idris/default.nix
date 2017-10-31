{ stdenv, fetchurl, emacs }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "idris-mode";
  version = "0.9.18";

  src = fetchurl {
    url = "https://github.com/idris-hackers/${pname}/archive/${version}.tar.gz";
    sha256 = "06rw5lrxqqnw0kni3x9jm73x352d1vb683d41v8x3yzqfa2sxmwg";
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
    description = "Emacs major mode for Idris";
    homepage = https://github.com/idris-hackers/idris-mode;
    license = stdenv.lib.licenses.gpl3;

    platforms = stdenv.lib.platforms.all;
  };
}
