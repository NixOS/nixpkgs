{ scala, fetchurl }:

scala.bare.overrideAttrs (oldAttrs: {
  version = "3.8.4";
  pname = "scala-next";
  src = fetchurl {
    inherit (oldAttrs.src) url;
    hash = "sha256-yy+aNY7ESe7EF9Y+/Ztvxr1moTsTR9ScJVceyihIV9M=";
  };
})
