{ hostPlatform, callPackage }: {
  signal-desktop = if hostPlatform.system == "aarch64-linux"
    then callPackage ./signal-desktop-aarch64.nix { }
    else callPackage ./signal-desktop.nix { };
  signal-desktop-beta = callPackage ./signal-desktop-beta.nix{ };
}
