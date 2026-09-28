{
  runCommand,
  emacs,
  hello,
  replaceVars,
  lib,
}:

let
  mkEpkg =
    {
      pname,
      version ? "0.1.0", # a dummy value
      src ? lib.path.append ./. "${pname}.el",
    }:

    {
      melpaBuild,
    }:
    melpaBuild {
      inherit pname version src;
      turnCompilationWarningToError = true;
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
          src = replaceVars ./with-packages.el { inherit (builtins) storeDir; };
        }) { })
        (epkgs.callPackage (mkEpkg { pname = "early-default"; }) { })
        (epkgs.callPackage (mkEpkg { pname = "default"; }) { })
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
