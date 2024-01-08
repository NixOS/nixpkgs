let
  pkgs = import ../../../../.. {};

  emacsEnv = pkgs.emacs.pkgs.withPackages(epkgs: with epkgs; [
    promise semaphore ]);
in pkgs.mkShell {
  packages = [
    pkgs.git
    pkgs.nix
    pkgs.bash
    pkgs.nix-prefetch-git
    pkgs.nix-prefetch-hg
    emacsEnv
  ];
}
