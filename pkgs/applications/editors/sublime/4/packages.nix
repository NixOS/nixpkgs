{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
{
  sublime4 = common {
    buildVersion = "4186";
    x64sha256 = "Rw/N2uSsMb6uMvMt9lEzBFSAvAePFTwfX09ARDX1mSs=";
    aarch64sha256 = "6RKaSIDj0zOqjYAGb77q3+sKqmp+VFqcgODyU06ajrc=";
  } { };

  sublime4-dev = common {
    buildVersion = "4178";
    dev = true;
    x64sha256 = "2eTdb5MzXK3QbAEzl1yxURj4m/PqGHPVnHZV2WzD6Jc=";
    aarch64sha256 = "NLLOB4WnujMx3+wf6Evi+yBWM6463EZoNL2wEdJA8BA=";
  } { };
}
