{
  lib,
  ansi,
  cask,
  cl-generic,
  cl-lib,
  commander,
  epl,
  f,
  fetchFromGitHub,
  installShellFiles,
  git,
  melpaBuild,
  package-build,
  s,
  shut-up,
}:
let
  getAllDependenciesOfPkg =
    pkg:
    let
      direct = builtins.filter (x: x != null) (pkg.packageRequires or [ ]);
      indirect = builtins.concatLists (map getAllDependenciesOfPkg direct);
    in
    lib.unique (direct ++ indirect);
  dependencies = getAllDependenciesOfPkg cask;
  load-path-mod = builtins.concatStringsSep "\n" (
    map (
      x:
      "(add-to-list 'load-path \\\"${x.outPath}/share/emacs/site-lisp/elpa/${x.pname}-${x.version}/\\\")"
    ) dependencies
  );
  deps-mod = builtins.concatStringsSep " " (map (x: x.pname) dependencies);
in
melpaBuild (finalAttrs: {
  pname = "cask";
  version = "0.9.1";

  src = fetchFromGitHub {
    name = "cask-source-${finalAttrs.version}";
    owner = "cask";
    repo = "cask";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/vinpQ51AuaTbXW4L4MnVonyfzTMvHUF4HViSPBKZxs=";
  };

  nativeBuildInputs = [ installShellFiles ];

  patches = [
    # Uses LISPDIR substitution var
    ./0000-cask-lispdir.diff
    # Use Nix provided dependencies instead of letting Cask bootstrap itself
    ./0001-cask-bootstrap.diff
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

  # use melpaVersion so that it works for unstable releases too
  postPatch = ''
    export lispdir=$out/share/emacs/site-lisp/elpa/cask-${finalAttrs.melpaVersion}
    substituteAllInPlace bin/cask

    substituteInPlace cask-bootstrap.el \
      --replace "@deps-mod@" "${deps-mod}" \
      --replace "@load-path-mod@" "${load-path-mod}"
  '';

  postInstall = ''
    installBin bin/cask
  '';

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
    maintainers = with lib.maintainers; [ ];
  };
})
