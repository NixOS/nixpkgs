{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "ess-R-object-popup-20130302";

  src = fetchgit {
    url = "https://github.com/myuhe/ess-R-object-popup.el.git";
    rev = "7e1f601bfba72de0fda44d9c82f96028ecbb9948";
    sha256 = "0q8pbaa6wahli6fh0kng5zmnypsxi1fr2bzs2mfk3h8vf4nikpv0";
  };

  installPhase = ''
    mkdir -p $out/share/emacs/site-lisp
    cp *.el *.elc $out/share/emacs/site-lisp/
  '';

  meta = {
    description = "Popup descriptions of R objects";
    homepage = "https://github.com/myuhe/ess-R-object-popup.el";
    platforms = stdenv.lib.platforms.all;
  };
}
