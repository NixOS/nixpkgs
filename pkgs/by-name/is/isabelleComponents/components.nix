{ lib, newScope }:

lib.makeScope newScope (self: {
  isabelle-linter = self.callPackage ./isabelle-linter { };
  vampire = self.callPackage ./vampire { };
})
