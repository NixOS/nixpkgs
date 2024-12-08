{ system, pkgs, ... }:

{
  git = import ./git.nix { inherit system pkgs; };
  builds = import ./builds.nix { inherit system pkgs; };
}
