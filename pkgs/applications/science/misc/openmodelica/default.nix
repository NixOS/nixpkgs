{
  lib,
  newScope,
  libsForQt5,
  clangStdenv,
}:
lib.makeScope newScope (
  self:
  let
    callPackage = self.newScope { stdenv = clangStdenv; };
    callQtPackage = self.newScope (libsForQt5 // { stdenv = clangStdenv; });
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
