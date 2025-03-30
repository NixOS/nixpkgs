{
  runCommand,
  emacs,
  git,
}:

runCommand "test-emacs-withPackages-wrapper"
  {
    nativeBuildInputs = [
      (emacs.pkgs.withPackages (
        epkgs: with epkgs; [
          magit
        ]
      ))
      git # needed by magit
    ];
  }
  ''
    emacs --batch --eval="(require 'magit)"
    touch $out
  ''
