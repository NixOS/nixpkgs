{
  lib,
  ansi,
  cl-generic,
  cl-lib,
  commander,

  epl,
  f,
  fetchFromGitHub,
  git,
  gitUpdater,
  melpaBuild,
  package-build,
  s,
  shut-up,
}:

melpaBuild (finalAttrs: {
  pname = "cask";
  version = "0.9.0";

  src = fetchFromGitHub {
    name = "cask-source-${finalAttrs.version}";
    owner = "cask";
    repo = "cask";
    rev = "v${finalAttrs.version}";
    hash = "sha256-91rJFsp2SLk/JY+v6G5JmXH5bg9QnT+qhI8ccNJlI4A=";
  };

  patches = [
    # Uses LISPDIR substitution var
    ./0000-cask-lispdir.diff
  ];

  packageRequires = [
    ansi
    cl-generic
    cl-lib
    commander
    epl
    f
    git
    package-build
    s
    shut-up
  ];

  ignoreCompilationError = false;

  strictDeps = true;

  # use melpaVersion so that it works for unstable releases too
  postPatch = ''
    lispdir=$out/share/emacs/site-lisp/elpa/cask-${finalAttrs.melpaVersion} \
      substituteAllInPlace bin/cask
  '';

  # TODO: use installBin as soon as installBin arrives Master branch
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
