{ fetchurl }:
let
  fetchTestInput =
    { res, sha256 }:
    fetchurl {
      inherit sha256;
      url = "https://www.mkgmap.org.uk/testinput/${res}";
      name = builtins.replaceStrings [ "/" ] [ "__" ] res;
    };
in
[
  (fetchTestInput {
    res = "osm/alaska-2016-12-27.osm.pbf";
    sha256 = "0hmb5v71a1bxgvrg1cbfj5l27b3vvdazs4pyggpmhcdhbwpw7ppm";
  })
  (fetchTestInput {
    res = "osm/hamburg-2016-12-26.osm.pbf";
    sha256 = "08bny4aavwm3z2114q99fv3fi2w905zxi0fl7bqgjyhgk0fxjssf";
  })
]
