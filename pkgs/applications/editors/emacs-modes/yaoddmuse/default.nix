{stdenv, fetchurl, emacs}:

stdenv.mkDerivation rec {
  name = "yaoddmuse-0.1.2";

  src = fetchurl {
    url = "http://emacswiki.org/emacs/download/yaoddmuse.el";
    sha256 = "0vlllq3xmnlni0ws226pqxj68nshclbl5rgqv6y11i3yvzgiazr6";
  };

  phases = [ "buildPhase" "installPhase"];

  buildInputs = [ emacs ];

  buildPhase = ''
    cp $src yaoddmuse.el
    emacs --batch -f batch-byte-compile yaoddmuse.el
  '';

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install yaoddmuse.el $out/share/emacs/site-lisp
  '';

  meta = {
    description = "Comprehensive Emacs integration with Oddmuse wikis";
    homepage = http://emacswiki.org/emacs/Yaoddmuse;
    platforms = stdenv.lib.platforms.all;
  };
}
