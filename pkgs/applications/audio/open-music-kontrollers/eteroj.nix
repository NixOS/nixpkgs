{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "eteroj";
  version = "0.10.0";

  sha256 = "18iv1sdwm0g6b53shsylj6bf3svmvvy5xadhfsgb4xg39qr07djz";

  description = "OSC injection/ejection from/to UDP/TCP/Serial for LV2";
})
