with import <localpkgs> {};
let
  inherit (vimUtils.override {inherit vim;}) buildVimPluginFrom2Nix;
  inherit (neovimUtils) buildNeovimPluginFrom2Nix;

  generated = callPackage <localpkgs/pkgs/applications/editors/vim/plugins/generated.nix> {
    inherit buildNeovimPluginFrom2Nix buildVimPluginFrom2Nix;
  } {} {};
  hasChecksum = value:
    lib.isAttrs value && lib.hasAttrByPath ["src" "outputHash"] value;
  getChecksum = name: value:
    if hasChecksum value then {
      submodules = value.src.fetchSubmodules or false;
      sha256 = value.src.outputHash;
      rev = value.src.rev;
    } else null;
  checksums = lib.mapAttrs getChecksum generated;
in
  lib.filterAttrs (n: v: v != null) checksums
