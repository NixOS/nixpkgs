{ scala, fetchurl }:

scala.bare.overrideAttrs (oldAttrs: {
  version = "3.7.3";
  pname = "scala-next";
  src = fetchurl {
    inherit (oldAttrs.src) url;
    hash = "sha256-KmIgDOX4TtioGvcDJ0+sGxq+fFqlKM/hZNBb0Q+7Z8A=";
  };
})
