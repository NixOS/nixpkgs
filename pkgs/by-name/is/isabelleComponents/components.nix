{ lib, newScope }:

lib.makeScope newScope (self: {
  isabelle-linter = self.callPackage ./isabelle-linter { };
  polyml = self.callPackage ./polyml { };
  sha1 = self.callPackage ./sha1 { };
  vampire = self.callPackage ./vampire { };
})
