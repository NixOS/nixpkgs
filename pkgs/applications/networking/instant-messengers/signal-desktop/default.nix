{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.2.0";
    hash = "sha256-auOcMlwKPj5rsnlhK34sYe4JxlHCjb3e2ye8Cs12Qtc=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.1.0-beta.1";
    hash = "sha256-zfXHSAYJH9/y0IaB6dTb1T85hZzDXyNX6sCpaHnL32k=";
  };
}
