{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  brand = "Midas";
  type = "M32";
  version = "3.2";
  sha256 = "1cds6qinz37086l6pmmgrzrxadygjr2z96sjjyznnai2wz4z2nrd";
  homepage = "http://www.musictri.be/Categories/Midas/Mixers/Digital/M32/p/P0B3I/downloads";
})
