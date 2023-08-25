# generic builder for Emacs packages

{ lib, stdenv, emacs, texinfo, writeText, gcc, ... }:

{ pname
, version ? null
, buildInputs ? []
, packageRequires ? []
, meta ? {}
, ...
}@args:

let
  defaultMeta = {
    broken = false;
    platforms = emacs.meta.platforms;
  } // lib.optionalAttrs ((args.src.meta.homepage or "") != "") {
    homepage = args.src.meta.homepage;
  };
in

stdenv.mkDerivation ({
  name = "emacs-${pname}${lib.optionalString (version != null) "-${version}"}";

  unpackCmd = ''
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

  buildInputs = [emacs texinfo] ++ packageRequires ++ buildInputs;
  propagatedBuildInputs = packageRequires;
  propagatedUserEnvPkgs = packageRequires;

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

  doCheck = false;

  meta = defaultMeta // meta;
}

// lib.optionalAttrs (emacs.withNativeCompilation or false) {

  LIBRARY_PATH = "${lib.getLib stdenv.cc.libc}/lib";

  nativeBuildInputs = [ gcc ];

  addEmacsNativeLoadPath = true;

  postInstall = ''
    # Besides adding the output directory to the native load path, make sure
    # the current package's elisp files are in the load path, otherwise
    # (require 'file-b) from file-a.el in the same package will fail.
    mkdir -p $out/share/emacs/native-lisp
    source ${./emacs-funcs.sh}
    addEmacsVars "$out"

    find $out/share/emacs -type f -name '*.el' -print0 \
      | xargs -0 -I {} -n 1 -P $NIX_BUILD_CORES sh -c \
          "emacs --batch --eval '(setq large-file-warning-threshold nil)' -f batch-native-compile {} || true"
  '';
}

// removeAttrs args [ "buildInputs" "packageRequires" "meta" ])
