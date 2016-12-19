{ stdenv, fetchgit, emacs }:

stdenv.mkDerivation rec {
  name = "pcache-0.2.3";

  src = fetchgit {
    url = "https://github.com/sigma/pcache.git";
    rev = "fa8f863546e2e8f2fc0a70f5cc766a7f584e01b6";
    sha256 = "f7cdad5a729b24f96ec69db4adfd19daf45c27aaf3a0267385b252cb2e59daa0";
  };

  buildInputs = [ emacs ];

  buildPhase = ''
    emacs --batch -f batch-byte-compile pcache.el
  '';

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install pcache.el pcache.elc $out/share/emacs/site-lisp
  '';

  meta = {
    description = "Persistent caching for Emacs";
    homepage = https://github.com/sigma/pcache.el;
    license = stdenv.lib.licenses.gpl2Plus;

    platforms = stdenv.lib.platforms.all;
  };
}
