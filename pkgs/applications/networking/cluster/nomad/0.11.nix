{ callPackage, buildGoPackage }:

callPackage ./generic.nix {
  inherit buildGoPackage;
  version = "0.11.8";
  sha256 = "1dhh07bifr02jh2lls8fv1d9ra67ymgh8qxqvpvm0cd0qdd469z1";
}
