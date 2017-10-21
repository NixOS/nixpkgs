{stdenv, fetchurl, emacs}:

let version = "2.0.2";

in stdenv.mkDerivation {
  name = "writegood-mode-${version}";
  src = fetchurl {
    url = "https://github.com/bnbeckwith/writegood-mode/archive/v${version}.tar.gz";
    sha256 = "1ilbqj24vzpfh9n1wph7idj0914ga290jkpv9kr1pff3a0v5hf6k";
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
    license = stdenv.lib.licenses.gpl3;
  };
}
