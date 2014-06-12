{ stdenv, fetchurl, emacs }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "idris-mode";
  version = "0.9.13.1";

  src = fetchurl {
    url = "https://github.com/idris-hackers/${pname}/archive/${version}.tar.gz";
    sha256 = "0ymjbkwsq7qra691wyldw91xcdgrbx3468vvrha5jj92v7nwb8wx";
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
    license = "GPLv3";

    platforms = stdenv.lib.platforms.all;
  };
}
