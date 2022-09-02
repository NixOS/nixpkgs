{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "5.1.0";
  kde-channel = "stable";
  sha256 = "sha256-mjs/WFhIC3CRvUhEmSbmE1OOqKTcBiSchg/+PaWs2II=";
})
