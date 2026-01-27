{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
{
  sublime-merge = common {
    buildVersion = "2121";
    aarch64sha256 = "WAT2gmAg63cu3FJIw5D3rRa+SNonymfsLaTY8ALa1ec=";
    x64sha256 = "yWrrlDe5C90EMQVdpENWnGURcVEdxJlFkalEfPpztzQ=";
  } { };

  sublime-merge-dev = common {
    buildVersion = "2120";
    dev = true;
    aarch64sha256 = "3JKxLke1l7l+fxhIJWbXbMHK5wPgjZTEWcZd9IvrdPM=";
    x64sha256 = "N8lhSmQnj+Ee1A2eIOkhdhQnHBK3B6vFA3vrPAbYtaI=";
  } { };
}
