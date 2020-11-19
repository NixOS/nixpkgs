{ pkgs, parinfer-rust, rep }:

{
  inherit parinfer-rust rep;

  case-kak = pkgs.callPackage ./case.kak.nix { };
  kak-ansi = pkgs.callPackage ./kak-ansi.nix { };
  kak-auto-pairs = pkgs.callPackage ./kak-auto-pairs.nix { };
  kak-buffers = pkgs.callPackage ./kak-buffers.nix { };
  kak-fzf = pkgs.callPackage ./kak-fzf.nix { };
  kak-plumb = pkgs.callPackage ./kak-plumb.nix { };
  kak-powerline = pkgs.callPackage ./kak-powerline.nix { };
  kak-prelude = pkgs.callPackage ./kak-prelude.nix { };
  kak-vertical-selection = pkgs.callPackage ./kak-vertical-selection.nix { };
}
