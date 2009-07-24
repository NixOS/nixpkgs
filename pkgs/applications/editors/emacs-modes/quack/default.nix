{ fetchurl, stdenv, emacs }:

stdenv.mkDerivation {
  name = "quack-0.37";

  src = fetchurl {
    # XXX: Upstream URL is not versioned, which might eventually break this.
    url = "http://www.neilvandyke.org/quack/quack.el";
    sha256 = "1q5442cpvw2i0qhmhn7mh45jnmzg0cmd01k5zp4gvg1526c0hbcc";
  };

  buildInputs = [ emacs ];

  unpackPhase = "true";
  configurePhase = "true";
  installPhase = "true";

  buildPhase = ''
    emacsDir="$out/share/emacs/site-lisp"

    ensureDir "$emacsDir"
    cp -v "$src" "$emacsDir/quack.el"
    emacs --batch -f batch-byte-compile "$emacsDir/quack.el"
  '';

  meta = {
    description = "Enhanced Emacs support for editing and running Scheme code";
    homepage = http://www.neilvandyke.org/quack/;
    license = "GPLv2+";
    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
