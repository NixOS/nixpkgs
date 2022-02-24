{ mkDerivation, aeson, base, fetchgit, freer-simple, lens, lib, mtl
, prettyprinter, streaming, text
}:
mkDerivation {
  pname = "freer-extras";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/plutus/";
    sha256 = "1jicyk4hr8p0xksj4048gdxndrb42jz4wsnkhc3ymxbm5v6snalf";
    rev = "1efbb276ef1a10ca6961d0fd32e6141e9798bd11";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/freer-extras; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base freer-simple lens mtl prettyprinter streaming text
  ];
  description = "Useful extensions to simple-freer";
  license = lib.licenses.asl20;
}
