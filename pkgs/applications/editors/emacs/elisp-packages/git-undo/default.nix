{ stdenv, fetchFromGitHub, emacs, lib }:

stdenv.mkDerivation {
  pname = "git-undo";
  version = "2019-10-13";

  src = fetchFromGitHub {
    owner = "jwiegley";
    repo = "git-undo-el";
    rev = "cf31e38e7889e6ade7d2d2b9f8719fd44f52feb5";
    sha256 = "sha256-cVkK9EF6qQyVV3uVqnBEjF8e9nEx/8ixnM8PvxqCyYE=";
  };

  buildInputs = [ emacs ];

  buildPhase = ''
    runHook preBuild
    emacs -L . --batch -f batch-byte-compile *.el
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -d $out/share/emacs/site-lisp
    install *.el *.elc $out/share/emacs/site-lisp
    runHook postInstall
  '';

  meta = {
    description = "Revert region to most recent Git-historical version";
    homepage = "https://github.com/jwiegley/git-undo-el";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ leungbk ];
    platforms = emacs.meta.platforms;
  };
}
