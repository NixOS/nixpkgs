{
  runCommand,
  emacs,
}:

runCommand "test-emacs-withPackages-wrapper"
  {
    nativeBuildInputs = [
      (emacs.pkgs.withPackages (
        epkgs: with epkgs; [
          dash
          flx-ido
        ]
      ))
    ];
    env = {
      # emulate a default NixOS env where INFOPATH is set like this (not ending with a ":")
      INFOPATH = "/fake-info-dir1:/fake-info-dir2";
    };
  }
  ''
    emacs --batch --eval="(require 'flx-ido)"
    # transitive dependencies should be made available
    # https://github.com/NixOS/nixpkgs/issues/388829
    emacs --batch --eval="(require 'flx)"

    emacs --batch --eval="(require 'dash)"
    # test that https://debbugs.gnu.org/cgi/bugreport.cgi?bug=81105 is fixed or worked around
    emacs --batch --eval='(progn (package-activate-all) (info "(dash)Top"))'

    touch $out
  ''
