{ hostPlatform, callPackage, lib }:
{
  signal-desktop = {
    x86_64-linux = callPackage ./signal-desktop.nix { };
    aarch64-linux = callPackage ./signal-desktop-aarch64.nix { };
    x86_64-darwin = callPackage ./signal-desktop-x86_64-darwin.nix { };
    aarch64-darwin = callPackage ./signal-desktop-aarch64-darwin.nix { };
  }.${hostPlatform.system};
  signal-desktop-beta = callPackage ./signal-desktop-beta.nix{ };
}
