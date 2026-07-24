{
  runCommand,
  emacs,
  writeText,
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
      (emacs.pkgs.withPackages (
        epkgs: with epkgs; [
          dash
          flx-ido
          (mkEpkg "with-packages" ./with-packages.el epkgs.melpaBuild)
        ]
      ))
    ];
    env = {
      # emulate a default NixOS env where INFOPATH is set like this (not ending with a ":")
      INFOPATH = "/fake-info-dir1:/fake-info-dir2";
      EMACS_TEST_VERBOSE = 1; # make ERT output verbose
    };
  }
  ''
    emacs --batch --load=with-packages --funcall=ert-run-tests-batch-and-exit

    touch $out
  ''
