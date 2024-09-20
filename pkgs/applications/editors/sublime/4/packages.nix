{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
{
  sublime4 = common {
    buildVersion = "4180";
    x64sha256 = "pl42AR4zWF3vx3wPSZkfIP7Oksune5nsbmciyJUv8D4=";
    aarch64sha256 = "zRg2jfhi+g6iLrMF1TGAYT+QQKSNI1W4Yv1bz9oEXHg=";
  } { };

  sublime4-dev = common {
    buildVersion = "4178";
    dev = true;
    x64sha256 = "2eTdb5MzXK3QbAEzl1yxURj4m/PqGHPVnHZV2WzD6Jc=";
    aarch64sha256 = "NLLOB4WnujMx3+wf6Evi+yBWM6463EZoNL2wEdJA8BA=";
  } { };
}
