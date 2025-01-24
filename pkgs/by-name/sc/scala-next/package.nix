{ scala, fetchurl }:

scala.bare.overrideAttrs (oldAttrs: {
  version = "3.5.1";
  pname = "scala-next";
  src = fetchurl {
    inherit (oldAttrs.src) url;
    hash = "sha256-pRfoCXFVnnEh3zyB9HbUZK3qrQ94Gq3iXX2fWGS/l9o=";
  };
})
