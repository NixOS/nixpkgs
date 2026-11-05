{
  lib,
  newScope,
}:

lib.makeScope newScope (self: {
  capsules = self.callPackage ./capsules/package.nix { };
  metrics = self.callPackage ./metrics/package.nix { };
  openai-endpoint = self.callPackage ./openai-endpoint/package.nix { };
})
