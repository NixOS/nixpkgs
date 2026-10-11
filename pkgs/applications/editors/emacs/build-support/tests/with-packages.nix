{
  runCommand,
  emacs,
  hello,
  replaceVarsWith,
  lib,
  writeShellApplication,
}:

let
  mkEpkg = import ./mk-epkg.nix { inherit lib; };

  run-test = writeShellApplication {
    name = "run-test";
    runtimeInputs = [
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
    runtimeEnv = {
      # emulate a default NixOS env where INFOPATH is set like this (not ending with a ":")
      INFOPATH = "/fake-info-dir1:/fake-info-dir2";
      EMACS_TEST_VERBOSE = 1; # make ERT output verbose
    };
    text = ''
      # Give Emacs a HOME to emulate a real user environment.
      HOME="$PWD"

      nonBatchEmacsSocket="$PWD/non-batch-emacs-socket"
      emacs --daemon="$nonBatchEmacsSocket"

      emacs --batch --load=with-packages \
        --eval="(setq with-packages-non-batch-emacs-socket \"$nonBatchEmacsSocket\")" \
        --eval='(setq with-packages-unwrapped-emacs-program "${lib.getExe emacs}")' \
        --funcall=ert-run-tests-batch-and-exit
    '';
  };
in
runCommand "test-emacs-withPackages-wrapper"
  {
    nativeBuildInputs = [
      run-test
    ];
  }
  ''
    run-test

    touch $out
  ''
