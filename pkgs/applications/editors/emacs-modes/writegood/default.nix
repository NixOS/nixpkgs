{stdenv, fetchurl, emacs}:

let version = "2.0";

in stdenv.mkDerivation {
  name = "writegood-mode-${version}";
  src = fetchurl {
    url = "https://github.com/bnbeckwith/writegood-mode/archive/v${version}.tar.gz";
    sha256 = "0wf7bj9d00ggy3xigym885a3njfr98i3aqrrawf8x6lgbfc56dgp";
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
    description = "Emacs minor mode that aids in finding common writing problems";
    homepage = https://github.com/bnbeckwith/writegood-mode;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.pSub ];
    license = "GPL3";
  };
}
