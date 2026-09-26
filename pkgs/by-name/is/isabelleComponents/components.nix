{ lib, newScope }:

lib.makeScope newScope (self: {
  # Helpers
  addSettings = self.callPackage ./add-settings.nix { };

  # Components
  cvc5 = self.callPackage ./cvc5 { };
  isabelle-linter = self.callPackage ./isabelle-linter { };
  jdk = self.callPackage ./jdk { };
  polyml = self.callPackage ./polyml { };
  sha1 = self.callPackage ./sha1 { };
  vampire = self.callPackage ./vampire { };
})
