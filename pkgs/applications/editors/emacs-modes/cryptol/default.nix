{ stdenv, fetchurl, emacs }:

stdenv.mkDerivation rec {
  name    = "cryptol-mode-${version}";
  version = "0.1.0";

  src = fetchurl {
    url    = "https://github.com/thoughtpolice/cryptol-mode/archive/v${version}.tar.gz";
    sha256 = "1qyrqvfgpg1nyk1clv7v94r3amm02613hrak5732xzn6iak81cc0";
  };

  buildInputs = [ emacs ];

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install *.el *.elc $out/share/emacs/site-lisp
  '';

  meta = {
    description = "Emacs major mode for Cryptol";
    homepage    = "https://thoughtpolice/cryptol-mode";
    license     = stdenv.lib.licenses.gpl3Plus;
    platforms   = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
