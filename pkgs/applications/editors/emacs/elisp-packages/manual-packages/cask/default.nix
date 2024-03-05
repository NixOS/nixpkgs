{ lib
, stdenv
, fetchFromGitHub
, bash
, emacs
, python3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cask";
  version = "0.8.8";

  src = fetchFromGitHub {
    owner = "cask";
    repo = "cask";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TlReq5sLVJj+pXmJSnepKQkNEWVhnh30iq4egM1HJMU=";
  };

  doCheck = true;

  nativeBuildInputs = [ emacs ];
  buildInputs = [
    bash
    python3
  ]
  ++ (with emacs.pkgs; [
    ansi
    dash
    ecukes
    el-mock
    ert-async
    ert-runner
    f
    git
    noflet
    package-build
    s
    servant
    shell-split-string
  ]);

  strictDeps = true;

  buildPhase = ''
    runHook preBuild

    emacs --batch -L . -f batch-byte-compile cask.el cask-cli.el

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm444 -t $out/share/emacs/site-lisp/cask *.el *.elc
    install -Dm555 -t $out/share/emacs/site-lisp/cask/bin bin/cask
    ln -s $out/share/emacs/site-lisp/cask/bin/cask $out/bin/cask

    runHook postInstall
  '';

  meta = with lib; {
    description = "Project management for Emacs";
    longDescription = ''
      Cask is a project management tool for Emacs that helps automate the
      package development cycle; development, dependencies, testing, building,
      packaging and more.
    '';
    homepage = "https://cask.readthedocs.io/en/latest/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    inherit (emacs.meta) platforms;
  };
})
