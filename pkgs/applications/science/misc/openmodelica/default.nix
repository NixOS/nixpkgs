{
  lib,
  newScope,
  qt6,
  clangStdenv,
}:
lib.makeScope newScope (
  self:
  let
    callPackage = self.newScope { stdenv = clangStdenv; };
    callQtPackage = self.newScope (qt6 // { stdenv = clangStdenv; });
  in
  {
    mkOpenModelicaDerivation = callPackage ./mkderivation { };
    omcompiler = callPackage ./omcompiler { };
    omplot = callQtPackage ./omplot { };
    omsimulator = callPackage ./omsimulator { };
    omparser = callPackage ./omparser { };
    omedit = callQtPackage ./omedit { };
    omlibrary = callPackage ./omlibrary { };
    omshell = callQtPackage ./omshell { };
    combined = callPackage ./combined { };
  }
)
