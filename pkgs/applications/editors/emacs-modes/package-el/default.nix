{ stdenv, runCommand, emacs, gnutar}:

args @ { name, src, deps ? [], flags ? [], ... }:

with stdenv.lib;

let
  requireName = (builtins.parseDrvName name).name;
  packageFile = concatStringsSep "." [name (last (splitString "." src.name))];
in
stdenv.mkDerivation ({

  unpackPhase = ''
    # This is actually a hack. `
    cp -v ${src} ${packageFile};
  '';

  buildPhase = ''
    runHook preBuild

    mkdir -pv $out/share/emacs/elpa/
    ${emacs}/bin/emacs --batch --eval '
      (progn
        (setq debug-on-error t)
        (load "'${emacs}/share/emacs/site-lisp/site-start.el'")
        (setq package-user-dir (expand-file-name "'./share/emacs/elpa/'"))
        (require (quote package))
        (package-initialize)
        (package-install-file "./${packageFile}"))'
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
