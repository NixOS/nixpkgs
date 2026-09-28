{
  runCommand,
  emacs,
  hello,
  replaceVarsWith,
  lib,
}:

let
  mkEpkg =
    {
      pname,
      version ? "0.1.0", # a dummy value
      src ? lib.path.append ./. "${pname}.el",
      doLint ? true,
    }:

    {
      melpaBuild,
      package-lint,
    }:
    melpaBuild {
      inherit pname version src;
      turnCompilationWarningToError = true;

      packageRequires = lib.optional doLint package-lint;

      doInstallCheck = doLint;
      preInstallCheck = ''
        lintEachFile() {
          find $out/share/emacs \
            -type f -name '*.el' \
            -not -name "*-pkg.el" -not -name "*-autoloads.el" \
            -print0 \
          | xargs --verbose -0 -I {} -n 1 -P "$NIX_BUILD_CORES" "$@"
        }

        lintEachFile \
          emacs --batch \
            --funcall=package-activate-all \
            --funcall=package-lint-batch-and-exit "{}"

        lintEachFile \
          emacs --batch \
            "{}" \
            --eval='(setopt checkdoc-arguments-in-order-flag t)' \
            --funcall=checkdoc-batch
      '';
    };
in
runCommand "test-emacs-withPackages-wrapper"
  {
    nativeBuildInputs = [
      (emacs.pkgs.withPackages (epkgs: [
        epkgs.dash
        epkgs.flx-ido
        (epkgs.callPackage (mkEpkg {
          pname = "with-packages";
          src = replaceVarsWith {
            src = ./with-packages.el;
            replacements = { inherit (builtins) storeDir; };

            # generate a file in a store path dir
            #   /nix/store/hash-with-packages.el/with-packages.el
            # instead of a store path file, which checkdoc doesn't like
            #   /nix/store/hash-with-packages.el
            dir = "/";
          };
        }) { })
        (epkgs.callPackage (mkEpkg {
          pname = "early-default";
          doLint = false; # no need to lint this simple file
        }) { })
        (epkgs.callPackage (mkEpkg {
          pname = "default";
          doLint = false; # no need to lint this simple file
        }) { })
        hello
        (epkgs.treesit-grammars.with-grammars (ps: [ ps.tree-sitter-nix ]))
      ]))
    ];
    env = {
      # emulate a default NixOS env where INFOPATH is set like this (not ending with a ":")
      INFOPATH = "/fake-info-dir1:/fake-info-dir2";
      EMACS_TEST_VERBOSE = 1; # make ERT output verbose
    };
  }
  ''
    # Give Emacs a HOME to emulate a real user environment.
    HOME="$PWD"

    nonBatchEmacsSocket="$PWD/non-batch-emacs-socket"
    emacs --daemon="$nonBatchEmacsSocket"

    emacs --batch --load=with-packages \
      --eval="(setq with-packages-non-batch-emacs-socket \"$nonBatchEmacsSocket\")" \
      --funcall=ert-run-tests-batch-and-exit

    touch $out
  ''
