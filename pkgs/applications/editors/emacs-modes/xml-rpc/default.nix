{stdenv, fetchurl, emacs}:

stdenv.mkDerivation rec {
  name = "xml-rpc-1.6.8";

  src = fetchurl {
    url = https://launchpadlibrarian.net/40270196/xml-rpc.el;
    sha256 = "0i8hf90yhrjwqrv7q1f2g1cff6ld8apqkka42fh01wkdys1fbm7b";
  };

  phases = [ "buildPhase" "installPhase"];

  buildInputs = [ emacs ];

  buildPhase = ''
    cp $src xml-rpc.el
    emacs --batch -f batch-byte-compile xml-rpc.el
  '';

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install xml-rpc.el* $out/share/emacs/site-lisp
  '';

  meta = {
    description = "Elisp implementation of clientside XML-RPC";
    homepage = https://launchpad.net/xml-rpc-el;
    license = "GPLv3+";

    platforms = stdenv.lib.platforms.all;
  };
}
