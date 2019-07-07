{stdenv, fetchurl, emacs}:

stdenv.mkDerivation rec {
  name = "color-theme-6.6.0";

  src = fetchurl {
    url = "mirror://savannah/color-theme/${name}.tar.gz";
    sha256 = "0yx1ghcjc66s1rl0v3d4r1k88ifw591hf814ly3d73acvh15zlsn";
  };

  # patches from http://aur.archlinux.org/packages.php?ID=54883
  patches = [ ./fix-build.patch ./gnus-bug.diff ];

  buildInputs = [ emacs ];

  installFlags = [ "ELISPDIR=$(out)/share/emacs/site-lisp" ];
  installTargets = "install-bin";

  meta = {
    description = "Emacs-lisp mode for skinning your Emacs";
    homepage = https://www.nongnu.org/color-theme;
    license = stdenv.lib.licenses.gpl2Plus;

    platforms = stdenv.lib.platforms.all;
  };
}
