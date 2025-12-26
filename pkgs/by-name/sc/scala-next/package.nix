{ scala, fetchurl }:

scala.bare.overrideAttrs (oldAttrs: {
  version = "3.7.4";
  pname = "scala-next";
  src = fetchurl {
    inherit (oldAttrs.src) url;
    hash = "sha256-D5AaAp3qGDxC1nTeZnb8PFquf/0duVrMzq2knqaQHlk=";
  };
})
