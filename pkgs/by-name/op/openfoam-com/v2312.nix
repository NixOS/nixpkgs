{ callPackage, lib }:
let
  openfoam = callPackage ./generic.nix {
    version = "2312";
    sourceRev = "39362aec251477eec47e51898ad7ff457c78ed85"; # from maintenance-v2312 branch
    sourceHash = "sha256-WFl2IggZTdWFs9VHbTT7sThdVWJZMEmR3KYV7/whmJA=";

    inherit openfoam;
  };
in
openfoam
