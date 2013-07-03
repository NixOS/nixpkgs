{ stdenv, emacs }:

with stdenv.lib;
let
  emacsMajorVersion = head (splitString "." emacs.version);
in
args @ { name, namePrefix ? "emacs"+emacsMajorVersion+"-", src, deps ? [], ... }:

let
  packageElSupported = if (versionOlder emacs.version "24")
    then throw "Building package.el packages is only supported on Emacs >= 24"
    else true;
  packageFile = if packageElSupported
    then concatStringsSep "." [name (last (splitString "." src.name))]
    else "";
  emacsInitialization = cmds: ''
     (condition-case err
        (progn
          (setq debug-on-error t)
          (load "'${emacs}/share/emacs/site-lisp/site-start.el'")
          (setq package-user-dir (expand-file-name "'./share/emacs/elpa/'"))
          (require (quote package))
          (package-initialize)
          ${cmds}
          (setq kill-emacs-hook nil))
        (error (progn
                 (setq kill-emacs-hook nil)
                 (error (error-message-string err)))))
  '';
in
stdenv.mkDerivation ({
  name = namePrefix+args.name;

  # Run the emacs setup hook when this package is a build input
  propagatedBuildInputs = (args.propagatedBuildInputs or []) ++ deps ++ [ emacs ];

  # The user wants the package and it's dependencies in his profile.
  # TODO: Should we automatically add emacs too?
  propagatedUserEnvPkgs = (args.propagatedUserEnvPkgs or []) ++ deps;

  # Make buildEmacsPackage Package useful with --run-env
  buildInputs = (args.buildInputs or []) ++ deps;

  phases = [ "unpackPhase" "buildPhase" "installPhase" "fixupPhase" "testPhase" ];

  unpackPhase = ''
    # This is actually a hack. package.el needs the correct filename,
    # not a nix-store filename.
    cp -v ${src} ${packageFile};
  '';

  buildPhase = ''
    runHook preBuild

    mkdir -pv $out/share/emacs/elpa/
    ${emacs}/bin/emacs --batch --eval \ '
      ${emacsInitialization ''(package-install-file "./${packageFile}")''};
      '

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    # Remove the installation file we copied overin the unpackPhase.
    rm ${packageFile};
    cp -rv share $out/
    runHook postInstall
  '';

  preFixup = ''
  '';

  testPhase = ''
    ${emacs}/bin/emacs --batch '
      ${emacsInitialization ''
        ;; Load any file where name contains test
        (cl-dolist (f (directory-files "." (quote full-path) "test.*\\.el"))
          (load-file f))
        (ert-run-tests-batch-and-exit)
      ''}'
  '';

  meta.description = if hasAttr "description" args then args.description else null;
})
