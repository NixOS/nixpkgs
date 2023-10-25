{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.34.1";
    hash = "sha256-1kffRXPQmtxIsLZVOgPXDnxUmY59q+1umy25cditRhw=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.35.0-beta.2";
    hash = "sha256-TgzqKGt3ojkjq+mIu0EtqXfnnZ/xulWjiuS5/0dlwIM=";
  };
}
