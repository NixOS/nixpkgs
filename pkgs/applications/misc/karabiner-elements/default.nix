{
  lib,
  callPackage,
}:
let
  inherit (lib) mapAttrs' nameValuePair;

  variants = {
    "14" = {
      version = "14.13.0";
      hash = "sha256-gmJwoht/Tfm5qMecmq1N6PSAIfWOqsvuHU8VDJY8bLw=";
    };
    "15" = {
      version = "15.5.0";
      hash = "sha256-96NQxmnU1W/g2O1Ll7qsslclFzsBPnHDJ+hmNpaUUXA=";
    };
  };

  callKarabinerElements = variant: callPackage ./generic.nix { inherit (variant) version hash; };
  mkKarabinerElements =
    versionSuffix: variant:
    nameValuePair "karabiner-elements_${versionSuffix}" (callKarabinerElements variant);
in
mapAttrs' mkKarabinerElements variants
