{ stdenv, emacs }:

args @ { name, src, deps ? [], ... }:

with stdenv.lib;

let
  packageElSupported = if (versionOlder emacs.version "24")
    then throw "Building package.el packages is only supported on Emacs >= 24"
    else true;
  packageFile = if packageElSupported
    then concatStringsSep "." [name (last (splitString "." src.name))]
    else "";
in
stdenv.mkDerivation ({
  unpackPhase = ''
    # This is actually a hack. package.el needs the correct filename,
    # not a nix-store filename.
    cp -v ${src} ${packageFile};
  '';

  buildPhase = ''
    runHook preBuild

    mkdir -pv $out/share/emacs/elpa/
    ${emacs}/bin/emacs --batch -Q --eval '
      (condition-case err
        (progn
          (setq debug-on-error t)
          (load "'${emacs}/share/emacs/site-lisp/site-start.el'")
          (setq package-user-dir (expand-file-name "'./share/emacs/elpa/'"))
          (require (quote package))
          (package-initialize)
          (package-install-file "./${packageFile}")
          (setq kill-emacs-hook nil))
        (error (progn
                 (setq kill-emacs-hook nil)
                 (error (error-message-string err)))))'
    rm ./${packageFile}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    cp -r * $out/
    runHook postInstall
  '';

  preFixup = ''
  '';
} // args // {
  # Run the emacs setup hook when this package is a build input
  propagatedBuildInputs = (args.propagatedBuildInputs or []) ++ [ emacs ];

  # # Make buildEmacsPackage Package useful with --run-env
  buildInputs = (args.buildInputs or []) ++ deps;
} )
