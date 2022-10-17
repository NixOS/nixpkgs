{ callPackage
, buildGoModule
}:

callPackage ./generic.nix {
  inherit buildGoModule;
  version = "1.3.6";
  sha256 = "sha256-E1+QFaakAsqeXxAfY80ExWVIud7Q/q2TaUVsmADjsgo=";
  vendorSha256 = "sha256-kgTRjPr7GsoBeE/s9wrmUWE5jv1ZmszfVDsVaRbdx14=";
}
