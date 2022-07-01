{ callPackage
, buildGoModule
}:

callPackage ./generic.nix {
  inherit buildGoModule;
  version = "1.3.1";
  sha256 = "03ckhqh5xznvhbk380ka0g9w9hrvsi389h5maw68f3g3acx68jm7";
  vendorSha256 = "08k5dxaq4r2q0km6y9mc14haski6l7hmhmzn5wjb961hwf5hkfgh";
}
