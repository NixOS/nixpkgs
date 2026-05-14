{ fetchurl }:
let
  fetchTestInput =
    { res, hash }:
    fetchurl {
      inherit hash;
      url = "https://www.mkgmap.org.uk/testinput/${res}";
      name = builtins.replaceStrings [ "/" ] [ "__" ] res;
    };
in
[
  (fetchTestInput {
    res = "osm/alaska-2016-12-27.osm.pbf";
    hash = "sha256-9d7DL1+wMVjve/4S/VXbe6wjaJFusfDyfn0FFc4uq0I=";
  })
  (fetchTestInput {
    res = "osm/hamburg-2016-12-26.osm.pbf";
    hash = "sha256-TmvZHZgPevnwOtSB2H8BiYvoxnYpYRKC+KPyrRTxdiE=";
  })
]
