{stdenv, fetchgit, emacs}:

stdenv.mkDerivation rec {
  name = "sunrise-commander-6r435";

  src = fetchgit {
    url = https://github.com/escherdragon/sunrise-commander.git;
    rev = "7a44ca7abd9fe79f87934c78d00dc2a91419a4f1";
    sha256 = "2909beccc9daaa79e70876ac6547088c2459b624c364dda1886fe4d7adc7708b";
  };

  buildInputs = [ emacs ];

  buildPhase = ''
    emacs -L . --batch -f batch-byte-compile *.el
  '';

  installPhase = ''
    mkdir -p $out/share/emacs/site-lisp
    install *.el* $out/share/emacs/site-lisp
  '';

  meta = {
    description = "Two-pane file manager for Emacs based on Dired and inspired by MC";
    homepage = http://www.emacswiki.org/emacs/Sunrise_Commander;
    license = "GPLv3+";

    platforms = stdenv.lib.platforms.all;
  };
}
