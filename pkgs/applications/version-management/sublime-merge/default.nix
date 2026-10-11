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
    buildVersion = "2131";
    dev = true;
    aarch64sha256 = "9tiHTnSiawmNnNkQXHQi5/e5g1BuBNsZ/JK4xKlu0Ic=";
    x64sha256 = "0NcyF9+hPC0pj9d6GCM0x2AFKM0d5AWdOgxIjMj2DuU=";
  } { };
}
