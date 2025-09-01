{ scala, fetchurl }:

scala.bare.overrideAttrs (oldAttrs: {
  version = "3.7.1";
  pname = "scala-next";
  src = fetchurl {
    inherit (oldAttrs.src) url;
    hash = "sha256-XIeG4T7TXPVAEMteD0BSWrAv7V1f7xrkLpbdpHFuWAw=";
  };
})
