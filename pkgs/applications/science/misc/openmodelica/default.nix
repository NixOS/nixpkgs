{ lib, newScope, libsForQt5, clangStdenv }:
lib.makeScope newScope (self:
  let
    callPackage = self.newScope libsForQt5;
  in
  {
    stdenv = clangStdenv;
    mkOpenModelicaDerivation = callPackage ./mkderivation { };
    omcompiler = callPackage ./omcompiler { };
    omplot = callPackage ./omplot { };
    omsimulator = callPackage ./omsimulator { };
    omparser = callPackage ./omparser { };
    omedit = callPackage ./omedit { };
    omlibrary = callPackage ./omlibrary { };
    omshell = callPackage ./omshell { };
    combined = callPackage ./combined { };
  })
