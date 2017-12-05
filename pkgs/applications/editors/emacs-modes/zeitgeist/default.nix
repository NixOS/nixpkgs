{ stdenv, fetchurl, emacs }:

stdenv.mkDerivation {
  name = "zeitgeist-20120221";

  unpackPhase = "true";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/alexmurray/dotfiles/master/.emacs.d/vendor/zeitgeist.el";
    sha256 = "0fssx3lp8ar3b1ichbagir7z17habv367l7zz719ipycr24rf1nw";
  };

  buildInputs = [ emacs ];

  installPhase = ''
    mkdir -p $out/share/emacs/site-lisp
    cp $src $out/share/emacs/site-lisp/zeitgeist.el
  '';

  meta = {
    description = "Integreate Emacs with Zeitgeist";
    homepage = http://zeitgeist-project.com/;
    platforms = stdenv.lib.platforms.all;
  };
}
