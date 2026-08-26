{
  runCommand,
  emacs,
  writeText,
  cowsay,
}:

let
  mkEpkg =
    pname: src: melpaBuild:
    melpaBuild {
      inherit pname src;
      version = "0.1.0"; # a dummy value
      turnCompilationWarningToError = true;
    };
in
runCommand "test-emacs-withPackages-wrapper"
  {
    nativeBuildInputs = [
      (emacs.pkgs.withPackages (epkgs: [
        epkgs.dash
        epkgs.flx-ido
        (mkEpkg "with-packages" ./with-packages.el epkgs.melpaBuild)
        (mkEpkg "early-default" ./early-default.el epkgs.melpaBuild)
        (mkEpkg "default" ./default.el epkgs.melpaBuild)
        cowsay
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
