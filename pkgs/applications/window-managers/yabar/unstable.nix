{ callPackage, attrs ? {} }:

let
  overrides = {
    version = "unstable-2017-09-09";

    rev    = "d3934344ba27f5bdf122bf74daacee6d49284dab";
    sha256 = "14zrlzva8i83ffg426mrf6yli8afwq6chvc7yi78ngixyik5gzhx";
  } // attrs;
in callPackage ./build.nix overrides
