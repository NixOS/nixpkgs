{ pkgs, parinfer-rust }:

{
  inherit parinfer-rust;

  kak-ansi = pkgs.callPackage ./kak-ansi.nix { };
  kak-auto-pairs = pkgs.callPackage ./kak-auto-pairs.nix { };
  kak-buffers = pkgs.callPackage ./kak-buffers.nix { };
  kak-fzf = pkgs.callPackage ./kak-fzf.nix { };
  kak-plumb = pkgs.callPackage ./kak-plumb.nix { };
  kak-powerline = pkgs.callPackage ./kak-powerline.nix { };
  kak-vertical-selection = pkgs.callPackage ./kak-vertical-selection.nix { };
}
