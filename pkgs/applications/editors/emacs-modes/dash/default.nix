{stdenv, fetchurl, emacs}:

let
  version = "2.12.1";
in
stdenv.mkDerivation {
  name = "emacs-dash-${version}";

  src = fetchurl {
    url = "https://github.com/magnars/dash.el/archive/${version}.tar.gz";
    sha256 = "082jl7mp4x063bpj5ad2pc5125k0d6p7rb89gcj7ny3lma9h2ij1";
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
