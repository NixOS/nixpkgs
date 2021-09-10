{ lib
, stdenv
, fetchFromGitHub
, emacs
}:

stdenv.mkDerivation {
  pname = "isearch-prop";
  version = "0.0.0+unstable=2019-05-01";

  src = fetchFromGitHub {
    owner = "emacsmirror";
    repo = "isearch-prop";
    rev = "4a2765f835dd115d472142da05215c4c748809f4";
    hash = "sha256-A1Kt4nm7iRV9J5yaLupwiNL5g7ddZvQs79dggmqZ7Rk=";
  };

  buildInputs = [
    emacs
  ];

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

  meta = with lib; {
    homepage = "https://www.emacswiki.org/emacs/IsearchPlus";
    description = "Search text- or overlay-property contexts";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ leungbk ];
    platforms = emacs.meta.platforms;
  };
}
