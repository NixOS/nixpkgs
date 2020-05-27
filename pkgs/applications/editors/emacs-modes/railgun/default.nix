{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "railgun-2012-10-17";

  src = fetchgit {
    url = "https://github.com/mbriggs/railgun.el.git";
    rev = "66aaa1b091baef53a69d0d7425f48d184b865fb8";
    sha256 = "00x09vjd3jz5f73qkf5v1y402zn8vl8dsyfwlq9z646p18ba7gyh";
  };

  installPhase = ''
    mkdir -p $out/share/emacs/site-lisp
    cp *.el *.elc $out/share/emacs/site-lisp/
  '';

  meta = {
    description = "Propel yourself through a rails project with the power of magnets";
    homepage = "https://github.com/mbriggs/railgun.el";
    platforms = stdenv.lib.platforms.all;
  };
}
