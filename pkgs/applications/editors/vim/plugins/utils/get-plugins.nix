with import <localpkgs> { };
let
  inherit (vimUtils.override { inherit vim; }) buildVimPlugin;

  generated = callPackage <localpkgs/pkgs/applications/editors/vim/plugins/generated.nix> {
    inherit buildVimPlugin;
  } { } { };

  hasChecksum =
    value:
    lib.isAttrs value
    && lib.hasAttrByPath [
      "src"
      "outputHash"
    ] value;

  parse = _name: value: {
    inherit (value) pname version;
    homePage = value.meta.homepage;
    checksum =
      if hasChecksum value then
        {
          submodules = value.src.fetchSubmodules or false;
          sha256 = value.src.outputHash;
          inherit (value.src) rev;
        }
      else
        null;
  };
in
lib.mapAttrs parse generated
