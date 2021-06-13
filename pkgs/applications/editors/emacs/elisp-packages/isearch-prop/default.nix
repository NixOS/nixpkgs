{ stdenv, fetchFromGitHub, emacs, lib }:

stdenv.mkDerivation {
  pname = "isearch-prop";
  version = "2019-05-01";

  src = fetchFromGitHub {
    owner = "emacsmirror";
    repo = "isearch-prop";
    rev = "4a2765f835dd115d472142da05215c4c748809f4";
    sha256 = "sha256-A1Kt4nm7iRV9J5yaLupwiNL5g7ddZvQs79dggmqZ7Rk=";
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
    description = "Search text- or overlay-property contexts";
    homepage = "https://www.emacswiki.org/emacs/download/isearch-prop.el";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ leungbk ];
    platforms = emacs.meta.platforms;
  };
}
