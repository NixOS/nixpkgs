{stdenv, fetchurl, emacs}:

let version = "1.9.0";

in stdenv.mkDerivation {
  name = "emacs-s-${version}";

  src = fetchurl {
    url = "https://github.com/magnars/s.el/archive/${version}.tar.gz";
    sha256 = "1gah2k577gvnmxlpw7zrz0jr571vghzhdv2hbgchlgah07czd091";
  };

  buildInputs = [ emacs ];

  buildPhase = ''
    emacs -L . --batch -f batch-byte-compile *.el
  '';

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install *.el *.elc $out/share/emacs/site-lisp
  '';
}
