{
  lib,
  newScope,
}:

lib.makeScope newScope (self: {
  openai-endpoint = self.callPackage ./openai-endpoint/package.nix { };
})
