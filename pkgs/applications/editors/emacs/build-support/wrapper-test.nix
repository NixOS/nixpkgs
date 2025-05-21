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
          flx-ido
        ]
      ))
      git # needed by magit
    ];
  }
  ''
    emacs --batch --eval="(require 'magit)"

    emacs --batch --eval="(require 'flx-ido)"
    # transitive dependencies should be made available
    # https://github.com/NixOS/nixpkgs/issues/388829
    emacs --batch --eval="(require 'flx)"
    touch $out
  ''
