{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.0.1";
    hash = "sha256-7Cojhz3wBPd/13uVg2MgJXvR9QMPZcwBibk/sCrRMAE=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.1.0-beta.1";
    hash = "sha256-zfXHSAYJH9/y0IaB6dTb1T85hZzDXyNX6sCpaHnL32k=";
  };
}
