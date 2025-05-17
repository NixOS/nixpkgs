{ scala, fetchurl }:

scala.bare.overrideAttrs (oldAttrs: {
  version = "3.7.0";
  pname = "scala-next";
  src = fetchurl {
    inherit (oldAttrs.src) url;
    hash = "sha256-T2zGqv2XSjdA3t0FaJvldcthgpgRrMTyiRznlgQOmBE=";
  };
})
