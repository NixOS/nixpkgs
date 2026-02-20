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
    buildVersion = "2122";
    dev = true;
    aarch64sha256 = "SfmEaBbJCiLXm8XZu8tPD4Sx7Se2S2Zxt+fbZwi5R3w=";
    x64sha256 = "5o4Vn/yfTU6anfPofNZBNaBCuXpPwJEQgFcPyExUxeo=";
  } { };
}
