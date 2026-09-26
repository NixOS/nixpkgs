{ lib, newScope }:

lib.makeScope newScope (self: {
  isabelle-linter = self.callPackage ./isabelle-linter { };
  polyml = self.callPackage ./polyml { };
  vampire = self.callPackage ./vampire { };
})
