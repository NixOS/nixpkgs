{ hostPlatform, callPackage }:
if hostPlatform.system == "aarch64-linux" then
  callPackage ./aarch64.nix { }
else
  callPackage ./x86_64.nix { }
