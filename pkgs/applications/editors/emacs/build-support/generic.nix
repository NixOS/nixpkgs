# generic builder for Emacs packages

{
  lib,
  stdenv,
  emacs,
  texinfo,
  writeText,
  ...
}:

let
  inherit (lib) optionalAttrs;

  setupHook = writeText "setup-hook.sh" ''
    source ${./emacs-funcs.sh}

    if [[ ! -v emacsHookDone ]]; then
      emacsHookDone=1

      # If this is for a wrapper derivation, emacs and the dependencies are all
      # run-time dependencies. If this is for precompiling packages into bytecode,
      # emacs is a compile-time dependency of the package.
      addEnvHooks "$hostOffset" addEmacsVars
      addEnvHooks "$targetOffset" addEmacsVars
    fi
  '';

  libBuildHelper = import ./lib-build-helper.nix;

in

libBuildHelper.extendMkDerivation' stdenv.mkDerivation (
  finalAttrs:

  {
    buildInputs ? [ ],
    nativeBuildInputs ? [ ],
    packageRequires ? [ ],
    propagatedBuildInputs ? [ ],
    propagatedUserEnvPkgs ? [ ],
    postInstall ? "",
    meta ? { },
    turnCompilationWarningToError ? false,
    ignoreCompilationError ? false,
    ...
  }@args:

  {
    name = args.name or "emacs-${finalAttrs.pname}-${finalAttrs.version}";

    unpackCmd =
      args.unpackCmd or ''
        case "$curSrc" in
          *.el)
            # keep original source filename without the hash
            local filename=$(basename "$curSrc")
            filename="''${filename:33}"
            cp $curSrc $filename
            chmod +w $filename
            sourceRoot="."
            ;;
          *)
            _defaultUnpack "$curSrc"
            ;;
        esac
      '';

    inherit packageRequires;
    buildInputs = finalAttrs.packageRequires ++ buildInputs;
    nativeBuildInputs = [
      emacs
      texinfo
    ] ++ nativeBuildInputs;
    propagatedBuildInputs = finalAttrs.packageRequires ++ propagatedBuildInputs;
    propagatedUserEnvPkgs = finalAttrs.packageRequires ++ propagatedUserEnvPkgs;

    setupHook = args.setupHook or setupHook;

    inherit turnCompilationWarningToError ignoreCompilationError;

    meta =
      {
        broken = false;
        platforms = emacs.meta.platforms;
      }
      // optionalAttrs ((args.src.meta.homepage or "") != "") {
        homepage = args.src.meta.homepage;
      }
      // meta;
  }

  // optionalAttrs (emacs.withNativeCompilation or false) {

    addEmacsNativeLoadPath = args.addEmacsNativeLoadPath or true;

    postInstall =
      ''
        # Besides adding the output directory to the native load path, make sure
        # the current package's elisp files are in the load path, otherwise
        # (require 'file-b) from file-a.el in the same package will fail.
        mkdir -p $out/share/emacs/native-lisp
        source ${./emacs-funcs.sh}
        addEmacsVars "$out"

        # package-activate-all is used to activate packages.  In other builder
        # helpers, package-initialize is used for this purpose because
        # package-activate-all is not available before Emacs 27.
        find $out/share/emacs -type f -name '*.el' -not -name ".dir-locals.el" -print0 \
          | xargs --verbose -0 -I {} -n 1 -P $NIX_BUILD_CORES sh -c \
              "emacs \
                 --batch \
                 -f package-activate-all \
                 --eval '(setq native-comp-eln-load-path (cdr native-comp-eln-load-path))' \
                 --eval '(let ((default-directory \"$out/share/emacs/site-lisp\")) (normal-top-level-add-subdirs-to-load-path))' \
                 --eval '(setq large-file-warning-threshold nil)' \
                 --eval '(setq byte-compile-error-on-warn ${
                   if finalAttrs.turnCompilationWarningToError then "t" else "nil"
                 })' \
                 -f batch-native-compile {} \
               || exit ${if finalAttrs.ignoreCompilationError then "0" else "\\$?"}"
      ''
      + postInstall;
  }

)
