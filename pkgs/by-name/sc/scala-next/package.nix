{ scala, fetchurl }:

scala.bare.overrideAttrs (oldAttrs: {
  version = "3.8.1";
  pname = "scala-next";
  src = fetchurl {
    inherit (oldAttrs.src) url;
    hash = "sha256-6RdU/L3zUQE7uiC7T1q8TptJCoMnKxk84CLXQ9Q0Ao8=";
  };
})
