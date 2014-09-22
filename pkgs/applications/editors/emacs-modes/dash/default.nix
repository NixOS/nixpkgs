{stdenv, fetchurl, emacs}:

let version = "1.5.0";

in stdenv.mkDerivation {
  name = "emacs-dash-${version}";

  src = fetchurl {
    url = "https://github.com/magnars/dash.el/archive/${version}.tar.gz";
    sha256 = "0c6jknzy306vn22vqlabxkwxfnllrd33spymi74fkirbxaxvp8kp";
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
