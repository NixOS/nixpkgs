{ targetPlatform, callPackage }: {
  signal-desktop = callPackage ./signal-desktop-${targetPlatform.system}.nix { };
  signal-desktop-beta = callPackage ./signal-desktop-beta.nix { };
}
