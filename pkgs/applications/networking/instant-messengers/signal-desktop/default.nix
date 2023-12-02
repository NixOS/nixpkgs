{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.40.0";
    hash = "sha256-vyXHlycPSyEyv938IKzGM6pdERHHerx2CLY/U+WMrH4=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.41.0-beta.1";
    hash = "sha256-XKHR9vhqRMuAatyTtnLFvVmTOs+4OR5At0VQUFIBX3Q=";
  };
}
