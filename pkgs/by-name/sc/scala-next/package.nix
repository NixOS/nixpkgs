{ scala, fetchurl }:

scala.bare.overrideAttrs (oldAttrs: {
  version = "3.6.3";
  pname = "scala-next";
  src = fetchurl {
    inherit (oldAttrs.src) url;
    hash = "sha256-I+PYPSRLS8Q0SJ/BEAoFwB7EcFERZpN5pGcD5cGwlNU=";
  };
})
