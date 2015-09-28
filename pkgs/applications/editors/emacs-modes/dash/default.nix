{stdenv, fetchurl, emacs}:

let
  version = "2.11.0";
in
stdenv.mkDerivation {
  name = "emacs-dash-${version}";

  src = fetchurl {
    url = "https://github.com/magnars/dash.el/archive/${version}.tar.gz";
    sha256 = "1piwcwilkxcbjxx832mhb7q3pz1fgwp203r581bpqcw6kd5x726q";
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
