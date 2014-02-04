{stdenv, fetchurl, emacs}:

let version = "1.2";

in stdenv.mkDerivation {
  name = "writegood-mode-${version}";
  src = fetchurl {
    url = "https://github.com/bnbeckwith/writegood-mode/archive/v${version}.tar.gz";
    sha256 = "1kgi2i5pq0vk751z079yp7kdw721cclfg9d9p28h3a8xbr95l7b6";
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
