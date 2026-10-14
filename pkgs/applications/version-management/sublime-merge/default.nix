{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
{
  sublime-merge = common {
    buildVersion = "2132";
    aarch64sha256 = "70KdQ9lqkhFSfWU9fkhuawJpEkj6bkeU+XlLJIGKK54=";
    x64sha256 = "As7Nj3vrEE6JmN/oZ8e4EzhY+qLpPYja7/FJUjDRs9g=";
  } { };

  sublime-merge-dev = common {
    buildVersion = "2126";
    dev = true;
    aarch64sha256 = "sqrcGszq1Vi0DDbPds7ABsM7i1/6EEErTAC/Og3wwhc=";
    x64sha256 = "2Jia6Ep6iVz8PI6G2L52CEMnYpOK+MPZiwC/YVn3O9I=";
  } { };
}
