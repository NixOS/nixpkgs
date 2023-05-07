{ lib, callPackage }:
{
  registry-lib = import ./registry-lib.nix { inherit lib; };

  unpackVsixHook = callPackage ./unpack-vsix-hook { };

  mkExtensionGeneral = callPackage ./make-extension-general.nix { };

  modifiers = callPackage ./modifiers { };
}
