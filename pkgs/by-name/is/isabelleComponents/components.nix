{ lib, newScope }:

lib.makeScope newScope (self: {
  # Helpers
  addSettings = self.callPackage ./add-settings.nix { };

  # Components
  bash_process = self.callPackage ./bash_process { };
  csdp = self.callPackage ./csdp { };
  cvc5 = self.callPackage ./cvc5 { };
  e = self.callPackage ./e { };
  isabelle-linter = self.callPackage ./isabelle-linter { };
  jdk = self.callPackage ./jdk { };
  nunchaku = self.callPackage ./nunchaku { };
  polyml = self.callPackage ./polyml { };
  sha1 = self.callPackage ./sha1 { };
  spass = self.callPackage ./spass { };
  vampire = self.callPackage ./vampire { };
  verit = self.callPackage ./verit { };
  vscode_extension = self.callPackage ./vscode_extension { };
  vscodium = self.callPackage ./vscodium { };
  z3 = self.callPackage ./z3 { };
  zipperposition = self.callPackage ./zipperposition { };
})
