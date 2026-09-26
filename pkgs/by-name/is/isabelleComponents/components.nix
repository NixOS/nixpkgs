{ lib, newScope }:

lib.makeScope newScope (self: {
  cvc5 = self.callPackage ./cvc5 { };
  isabelle-linter = self.callPackage ./isabelle-linter { };
  polyml = self.callPackage ./polyml { };
  sha1 = self.callPackage ./sha1 { };
  vampire = self.callPackage ./vampire { };
})
