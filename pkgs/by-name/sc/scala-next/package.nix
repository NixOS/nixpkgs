{ scala, fetchurl }:

scala.bare.overrideAttrs (oldAttrs: {
  version = "3.8.3";
  pname = "scala-next";
  src = fetchurl {
    inherit (oldAttrs.src) url;
    hash = "sha256-/2LoJ+seoXgT2X5f1eDSaQEQeHFz/h4eQ9na3MNUL6c=";
  };
})
