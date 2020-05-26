{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  brand = "Behringer";
  type = "X32";
  version = "3.2";
  sha256 = "1lzmhd0sqnlzc0khpwm82sfi48qhv7rg153a57qjih7hhhy41mzk";
  homepage = "http://www.musictri.be/Categories/Behringer/Mixers/Digital/X32/p/P0ASF/downloads";
})
