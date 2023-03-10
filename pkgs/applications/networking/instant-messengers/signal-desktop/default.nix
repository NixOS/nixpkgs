{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.7.0";
    hash = "sha256-njiVPTkzYdt7QZcpohXUI3hj/o+fO4/O0ZlQrq2oP6Y=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.8.0-beta.1";
    hash = "sha256-akQmGxDW6SBQCRLU6TgfODP8ZjEPsvaBvrkdd+6DqKs=";
  };
}
