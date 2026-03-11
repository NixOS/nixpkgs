{ scala, fetchurl }:

scala.bare.overrideAttrs (oldAttrs: {
  version = "3.8.2";
  pname = "scala-next";
  src = fetchurl {
    inherit (oldAttrs.src) url;
    hash = "sha256-gnNWp4pw09eS8ad+EJzD+j6pRrjSaEi7JF8nW+Uv144=";
  };
})
