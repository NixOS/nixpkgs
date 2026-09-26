{ lib, newScope }:

lib.makeScope newScope (self: {
  # Helpers
  addSettings = self.callPackage ./add-settings.nix { };

  # Components
  bash_process = self.callPackage ./bash_process { };
  bib2xhtml = self.callPackage ./bib2xhtml { };
  csdp = self.callPackage ./csdp { };
  cvc5 = self.callPackage ./cvc5 { };
  e = self.callPackage ./e { };
  easychair = self.callPackage ./easychair { };
  elm = self.callPackage ./elm { };
  eptcs = self.callPackage ./eptcs { };
  find_facts_web = self.callPackage ./find_facts_web { };
  flatlaf = self.callPackage ./flatlaf { };
  foiltex = self.callPackage ./foiltex { };
  fonts = self.callPackage ./fonts { };
  gnu-utils = self.callPackage ./gnu-utils { };
  isabelle-linter = self.callPackage ./isabelle-linter { };
  javamail = self.callPackage ./javamail { };
  jdk = self.callPackage ./jdk { };
  jedit = self.callPackage ./jedit { };
  jfreechart = self.callPackage ./jfreechart { };
  jortho = self.callPackage ./jortho { };
  jsvg = self.callPackage ./jsvg { };
  jsoup = self.callPackage ./jsoup { };
  kodkodi = self.callPackage ./kodkodi { };
  lipics = self.callPackage ./lipics { };
  llncs = self.callPackage ./llncs { };
  minisat = self.callPackage ./minisat { };
  nunchaku = self.callPackage ./nunchaku { };
  opam = self.callPackage ./opam { };
  polyml = self.callPackage ./polyml { };
  scala = self.callPackage ./scala { };
  setup = self.callPackage ./setup { };
  sha1 = self.callPackage ./sha1 { };
  spass = self.callPackage ./spass { };
  vampire = self.callPackage ./vampire { };
  verit = self.callPackage ./verit { };
  vscode_extension = self.callPackage ./vscode_extension { };
  vscodium = self.callPackage ./vscodium { };
  z3 = self.callPackage ./z3 { };
  zipperposition = self.callPackage ./zipperposition { };
})
