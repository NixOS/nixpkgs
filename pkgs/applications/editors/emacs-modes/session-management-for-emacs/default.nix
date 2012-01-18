{stdenv, fetchurl, emacs}:

stdenv.mkDerivation rec {
  name = "session-management-for-emacs-2.2a";
  
  src = fetchurl {
    url = "mirror://sourceforge.net/sourceforge/emacs-session/session-2.2a.tar.gz";
    sha256 = "0i01dnkizs349ahyybzy0mjzgj52z65rxynsj2mlw5mm41sbmprp";
  };
  
  buildInputs = [emacs];
  
  installPhase = ''
    mkdir -p "$out/share/emacs/site-lisp"
    cp lisp/*.el "$out/share/emacs/site-lisp/"
  '';

  meta = { 
    /* installation: add to your ~/.emacs
       (require 'session)
       (add-hook 'after-init-hook 'session-initialize)
    */
    description = "small session management for emacs";
    homepage = http://emacs-session.sourceforge.net/;
    license = "GPL";
  };
}
