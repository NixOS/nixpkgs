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
    buildVersion = "2134";
    dev = true;
    aarch64sha256 = "Wlkmp2hs9kJL8qZwWx43eVjtIOTLC9on5g4n63S+kuA=";
    x64sha256 = "SPLeo2juEAFk6NHSbdqPC880C9yFuxQJrRg8YmL2YiI=";
  } { };
}
