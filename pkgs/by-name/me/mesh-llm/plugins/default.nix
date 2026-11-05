{
  lib,
  newScope,
}:

lib.makeScope newScope (self: {
  agents = self.callPackage ./agents/package.nix { };
  blackboard = self.callPackage ./blackboard/package.nix { };
  capsules = self.callPackage ./capsules/package.nix { };
  flash-moe = self.callPackage ./flash-moe/package.nix { };
  metrics = self.callPackage ./metrics/package.nix { };
  openai-endpoint = self.callPackage ./openai-endpoint/package.nix { };
  powermetrics = self.callPackage ./powermetrics/package.nix { };
})
