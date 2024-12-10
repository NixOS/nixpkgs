{
  lib,
  stdenv,
  emacs,
  fetchFromSourcehut,
  xapian,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xapian-lite";
  version = "2.0.0";

  src = fetchFromSourcehut {
    owner = "~casouri";
    repo = "xapian-lite";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uFO5yxPHIUJjT3OV2hZKp7KgT3l73W95X2SAz6vhCpI=";
    domain = "sr.ht";
  };

  preBuild = ''
    rm emacs-module.h
  '';

  buildInputs = [
    xapian
    emacs
  ];

  installPhase = ''
    runHook preInstall

    install -Dm444 -t $out/share/emacs/site-lisp/ xapian-lite${stdenv.targetPlatform.extensions.sharedLibrary}

    runHook postInstall
  '';

  meta = {
    homepage = "https://git.sr.ht/~casouri/xapian-lite";
    description = "A minimal Emacs dynamic module for Xapian";
    maintainers = [ lib.maintainers.kotatsuyaki ];
    license = lib.licenses.gpl3Plus;
    inherit (emacs.meta) platforms;
  };
})
