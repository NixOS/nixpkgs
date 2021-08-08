{ lib
, stdenv
, fetchFromGitHub
, emacs
}:

stdenv.mkDerivation rec {
  pname = "nano-theme";
  version = "2021-06-05";

  src = fetchFromGitHub {
    owner = "rougier";
    repo  = pname;
    rev = "99ff1c5e78296a073c6e63b966045e0d83a136e7";
    hash = "sha256-IDVnl4J4hx2mlLaiA+tKxxRGcIyBULr2HBeY/GMHD90=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/emacs/site-lisp
    install *.el $out/share/emacs/site-lisp
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/rougier/nano-theme";
    description = "GNU Emacs / N Λ N O Theme";
    inherit (emacs.meta) platforms;
  };
}
