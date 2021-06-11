{ stdenv, fetchFromGitHub, emacs, lib }:

stdenv.mkDerivation {
  pname = "isearch-plus";
  version = "2021-01-01";

  src = fetchFromGitHub {
    owner = "emacsmirror";
    repo = "isearch-plus";
    rev = "376a8f9f8a9666d7e61d125abcdb645847cb8619";
    sha256 = "sha256-Kd5vpu+mI1tJPcsu7EpnnBcPVdVAijkAeTz+bLB3WlQ=";
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
    description = "Extensions to isearch";
    homepage = "https://www.emacswiki.org/emacs/download/isearch%2b.el";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ leungbk ];
    platforms = emacs.meta.platforms;
  };
}
