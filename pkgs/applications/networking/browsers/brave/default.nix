{ hostPlatform, callPackage }: {
  brave = if hostPlatform.system == "aarch64-linux"
    then callPackage ./brave-aarch64.nix { }
    else callPackage ./brave.nix { };
}
