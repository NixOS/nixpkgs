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
    buildVersion = "2135";
    dev = true;
    aarch64sha256 = "azlCrhj36vVd+qWbkSCL5IR06SXf+UMjRzPA8bXCqrs=";
    x64sha256 = "bNcmN/DEO6m4Asxd5eFEXSc5VvRyajwgF38BUXy2hLY=";
  } { };
}
