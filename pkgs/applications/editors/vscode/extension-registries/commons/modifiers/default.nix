{ lib, callPackage }:
{
  build = callPackage ./build.nix { };

  urls2vsix = callPackage ./urls2vsix.nix { };

  cookrefs = callPackage ./cookrefs.nix { };
}
