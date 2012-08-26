{stdenv, fetchurl, emacs}:

stdenv.mkDerivation rec {
  name = "sunrise-commander-6";

  src = fetchurl {
    url = "http://www.emacswiki.org/emacs/download/sunrise-commander.el";
    sha256 = "1bbpm00nc7ry0f2k4zaqbvp6w9py31asfcr9hddggc138pnfajvq";
  };

  phases = [ "buildPhase" "installPhase"];

  buildInputs = [ emacs ];

  buildPhase = ''
    cp $src sunrise-commander.el
    emacs --batch -f batch-byte-compile sunrise-commander.el
  '';

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install sunrise-commander.el* $out/share/emacs/site-lisp
  '';

  meta = {
    description = "Two-pane file manager for Emacs based on Dired and inspired by MC.";
    homepage = http://www.emacswiki.org/emacs/Sunrise_Commander;
    license = "GPLv3+";

    platforms = stdenv.lib.platforms.all;
  };
}
