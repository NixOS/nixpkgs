{
  lib,
  newScope,
}:

lib.makeScope newScope (self: {
  # Extra plugins (not the ones already vendored in install/package.json).
  # Each plugin should set passthru.pluginName to the npm package name.
  buildNodebbPlugin = self.callPackage ./build-plugin.nix { };
})
