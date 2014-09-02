{ stdenv, fetchurl, emacs }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "idris-mode";
  version = "0.9.14";

  src = fetchurl {
    url = "https://github.com/idris-hackers/${pname}/archive/${version}.tar.gz";
    sha256 = "1qlkbf14mcibp6h5r84fp5xdjspyaw1xdmnkmaxbypwjhhjg4s83";
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
