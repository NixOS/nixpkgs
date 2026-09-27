{
  lib,
  newScope,
  stdenv,
}:

lib.makeScope newScope (self: {
  # Helpers
  addSettings = self.callPackage ./add-settings.nix { };
  buildIsabelle = self.callPackage ./generic.nix { };

  # Isabelle versions
  isabelleWithJars =
    self.buildIsabelle
      {
        makeHeap = false;
        doCheck = false;
      }
      (cp: [
        cp.bash_process
        cp.flatlaf
        cp.fonts
        cp.jdk
        cp.javamail
        cp.jedit
        cp.jfreechart
        cp.jortho
        cp.jsvg
        cp.jsoup
        cp.kodkodi
        cp.polyml
        cp.postgresql_jdbc
        cp.scala
        cp.setup
        cp.solr
        cp.sqlite
        cp.xz-java
        cp.zstd-jni
      ]);

  isabelleWithProvers = self.buildIsabelle { } (
    cp:
    self.isabelleWithJars.componentsFn cp
    ++ [
      cp.csdp
      cp.cvc5
      cp.e
      cp.minisat
      cp.nunchaku
      cp.smbc
      cp.spass
      cp.vampire
      cp.verit
      cp.zipperposition
      # Needs to be below vampire and spass to allow it to detect them
      cp.naproche
    ]
    ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform cp.z3) [
      cp.z3
    ]
  );

  isabelle = self.isabelleWithProvers.withComponents (cp: [
    cp.bib2xhtml
    cp.elm
    cp.find_facts_web
    cp.lipics
    cp.llncs
    cp.opam
    cp.pdfjs
    cp.prismjs
    cp.rsync
    cp.stack
  ]);

  isabelleWithLinter = self.isabelle.withComponents (cp: [ cp.isabelle-linter ]);
  isabelleWithVSCodium = self.isabelle.withComponents (cp: [ cp.vscodium ]);
  isabelleUnfree = self.isabelle.withComponents (cp: [ cp.foiltex ]);
  isabelle-bin = self.callPackage ./binary { };

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
  mlton = self.callPackage ./mlton { };
  naproche = self.callPackage ./naproche { };
  nunchaku = self.callPackage ./nunchaku { };
  opam = self.callPackage ./opam { };
  pdfjs = self.callPackage ./pdfjs { };
  polyml = self.callPackage ./polyml { };
  postgresql_jdbc = self.callPackage ./postgresql_jdbc { };
  prismjs = self.callPackage ./prismjs { };
  rsync = self.callPackage ./rsync { };
  scala = self.callPackage ./scala { };
  setup = self.callPackage ./setup { };
  sha1 = self.callPackage ./sha1 { };
  smbc = self.callPackage ./smbc { };
  solr = self.callPackage ./solr { };
  spass = self.callPackage ./spass { };
  sqlite = self.callPackage ./sqlite { };
  stack = self.callPackage ./stack { };
  vampire = self.callPackage ./vampire { };
  verit = self.callPackage ./verit { };
  vscode_extension = self.callPackage ./vscode_extension { };
  vscodium = self.callPackage ./vscodium { };
  xz-java = self.callPackage ./xz-java { };
  z3 = self.callPackage ./z3 { };
  zipperposition = self.callPackage ./zipperposition { };
  zstd-jni = self.callPackage ./zstd-jni { };
})
