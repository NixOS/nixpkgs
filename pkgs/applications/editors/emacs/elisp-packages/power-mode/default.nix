{ lib
, stdenv
, fetchFromGitHub
, emacs
}:

stdenv.mkDerivation rec {
  pname = "power-mode";
  version = "2021-06-06";

  src = fetchFromGitHub {
    owner = "elizagamedev";
    repo  = "power-mode.el";
    rev = "940e0aa36220f863e8f43840b4ed634b464fbdbb";
    hash = "sha256-Wy8o9QTWqvH9cP7xsTpF5QSd4mWNIPXJTadoADKeHWY=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/emacs/site-lisp
    install *.el $out/share/emacs/site-lisp
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/rougier/nano-theme";
    description = "Imbue Emacs with power!";
    inherit (emacs.meta) platforms;
  };
}
