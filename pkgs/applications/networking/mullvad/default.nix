{
  lib,
  newScope,
}:
lib.makeScope newScope (self: {
  libwg = self.callPackage ./libwg.nix { };
  mullvad = self.callPackage ./mullvad.nix { };
})
