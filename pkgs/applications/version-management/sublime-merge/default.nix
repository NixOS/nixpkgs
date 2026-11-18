{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
{
  sublime-merge = common {
    buildVersion = "2136";
    aarch64sha256 = "YtEnzifgq/eQWtrTtp7A/7N8W1bLQsYr82islf1IoqM=";
    x64sha256 = "gwnbtxd2gphEzgYZzWcx/EYNnmhW5O0orEcgWZRgTE0=";
  } { };

  sublime-merge-dev = common {
    buildVersion = "2126";
    dev = true;
    aarch64sha256 = "sqrcGszq1Vi0DDbPds7ABsM7i1/6EEErTAC/Og3wwhc=";
    x64sha256 = "2Jia6Ep6iVz8PI6G2L52CEMnYpOK+MPZiwC/YVn3O9I=";
  } { };
}
