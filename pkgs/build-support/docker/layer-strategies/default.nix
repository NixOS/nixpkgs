{ writePython3, writeShellScript }:
let

  # See manual for documentation on these layer strategy algorithms:
  # ../../../../doc/builders/images/dockertools.section.md

  popularityWeightedBottom =
    let text = builtins.readFile ./popularity_weighted_bottom.sh;
    in writeShellScript "popularity-weighted-bottom" text;

  popularityWeightedTop = writePython3 "popularity-weighted-top" {
  } ./popularity_weighted_top.py;

in {
  inherit popularityWeightedBottom popularityWeightedTop;
}
