{
  lib,
  ansi,
  coreutils,
  dash,
  ecukes,
  el-mock,
  ert-async,
  ert-runner,
  f,
  fetchFromGitHub,
  git,
  gitUpdater,
  melpaBuild,
  noflet,
  package-build,
  s,
  servant,
  shell-split-string,
}:

melpaBuild (finalAttrs: {
  pname = "cask";
  version = "0.8.8";

  src = fetchFromGitHub {
    name = "cask-source-${finalAttrs.version}";
    owner = "cask";
    repo = "cask";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TlReq5sLVJj+pXmJSnepKQkNEWVhnh30iq4egM1HJMU=";
  };

  patches = [
    # Uses LISPDIR substitution var
    ./0000-cask-lispdir.diff
  ];

  packageRequires = [
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
  ];

  ignoreCompilationError = false;

  strictDeps = true;

  postPatch = ''
    lispdir=$out/share/emacs/site-lisp/elpa/cask-${finalAttrs.version} \
      substituteAllInPlace bin/cask
  '';

  postInstall = ''
    install -D -t $out/bin bin/cask
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    homepage = "https://github.com/cask/cask";
    description = "Project management for Emacs";
    longDescription = ''
      Cask is a project management tool for Emacs that helps automate the
      package development cycle; development, dependencies, testing, building,
      packaging and more.
    '';
    license = lib.licenses.gpl3Plus;
    mainProgram = "cask";
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
})
