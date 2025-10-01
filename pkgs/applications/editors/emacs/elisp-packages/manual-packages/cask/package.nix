{
  lib,
  ansi,
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
  replaceVars,
  s,
  shut-up,
}:
let
  formatLoadPath = x: ''"${x}/share/emacs/site-lisp/elpa/${x.ename}-${x.melpaVersion or x.version}"'';
  formatNativeLoadPath = x: ''"${x}/share/emacs/native-lisp"'';
  getAllDependenciesOfPkg =
    pkg:
    let
      direct = builtins.filter (x: x != null) (pkg.packageRequires or [ ]);
      indirect = builtins.concatLists (map getAllDependenciesOfPkg direct);
    in
    lib.unique (direct ++ indirect);
in
melpaBuild (
  finalAttrs:
  let
    nixpkgDependencies = getAllDependenciesOfPkg finalAttrs.finalPackage;
    loadPaths = builtins.concatStringsSep " " (map formatLoadPath nixpkgDependencies);
    nativeLoadPaths = builtins.concatStringsSep " " (
      map formatNativeLoadPath (nixpkgDependencies ++ [ (placeholder "out") ])
    );
    emacsBuiltinDeps = [
      "cl-lib"
      "eieio"
    ];
    depsMod = builtins.concatStringsSep " " ((map (x: x.ename) nixpkgDependencies) ++ emacsBuiltinDeps);
  in
  {
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

    postPatch = ''
      # use melpaVersion so that it works for unstable releases too
      substituteInPlace bin/cask \
        --replace-fail @lispdir@ $out/share/emacs/site-lisp/elpa/$ename-$melpaVersion

      # using `replaceVars` results in wrong result of `placeholder "out"`
      substituteInPlace cask-bootstrap.el \
        --replace-fail @depsMod@ '${depsMod}' \
        --replace-fail @loadPaths@ '${loadPaths}' \
        --replace-fail @nativeLoadPaths@ '${nativeLoadPaths}'
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
  }
)
