{ stdenv, fetchFromGitHub, emacs, emacsPackages, lib }:

let
  runtimeDeps = with emacsPackages; [
    evil
    markdown-mode
  ];
in
stdenv.mkDerivation {
  pname = "evil-markdown";
  version = "2020-06-01";

  src = fetchFromGitHub {
    owner = "Somelauw";
    repo = "evil-markdown";
    rev = "064fe9b4767470472356d20bdd08e2f30ebbc9ac";
    sha256 = "sha256-Kt2wxG1XCFowavVWtj0urM/yURKegonpZcxTy/+CrJY=";
  };

  buildInputs = [
    emacs
  ] ++ runtimeDeps;

  propagatedUserEnvPkgs = runtimeDeps;

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
    description = "Vim-like keybindings for markdown-mode";
    homepage = "https://github.com/Somelauw/evil-markdown";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ leungbk ];
    platforms = emacs.meta.platforms;
  };
}
