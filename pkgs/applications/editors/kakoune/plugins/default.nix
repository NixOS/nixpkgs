{ pkgs, parinfer-rust }:

{
  inherit parinfer-rust;
  kak-fzf = pkgs.callPackage ./kak-fzf.nix { };
  kak-powerline = pkgs.callPackage ./kak-powerline.nix { };
  kak-auto-pairs = pkgs.callPackage ./kak-auto-pairs.nix { };
  kak-vertical-selection = pkgs.callPackage ./kak-vertical-selection.nix { };
  kak-buffers = pkgs.callPackage ./kak-buffers.nix { };
}
