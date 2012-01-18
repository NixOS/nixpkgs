{ fetchurl, stdenv, emacs }:

stdenv.mkDerivation {
  name = "quack-0.39";

  src = fetchurl {
    # XXX: Upstream URL is not versioned, which might eventually break this.
    url = "http://www.neilvandyke.org/quack/quack.el";
    sha256 = "1w3p03f1f3l2nldxc7dig1kkgbbvy5j7zid0cfmkcrpp1qrcsqic";
  };

  buildInputs = [ emacs ];

  unpackPhase = "true";
  configurePhase = "true";
  installPhase = "true";

  buildPhase = ''
    emacsDir="$out/share/emacs/site-lisp"

    mkdir -p "$emacsDir"
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
