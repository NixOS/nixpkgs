{stdenv, fetchurl, emacs}:

let version = "1.3";

in stdenv.mkDerivation {
  name = "writegood-mode-${version}";
  src = fetchurl {
    url = "https://github.com/bnbeckwith/writegood-mode/archive/v${version}.tar.gz";
    sha256 = "0p34rgawnqg94vk4lcw14x99rrvsd23dmbwkxz2vax5kq6l8y5yf";
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
