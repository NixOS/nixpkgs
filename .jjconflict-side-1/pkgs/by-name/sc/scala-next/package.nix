{ scala, fetchurl }:

scala.bare.overrideAttrs (oldAttrs: {
  version = "3.6.4";
  pname = "scala-next";
  src = fetchurl {
    inherit (oldAttrs.src) url;
    hash = "sha256-I8Jpq/aelCJyAZzvNq5/QbfdD0Mk5mPuzTDxVdkIxKU=";
  };
})
