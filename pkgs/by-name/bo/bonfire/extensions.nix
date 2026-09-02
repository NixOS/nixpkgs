{
  _experimental-update-script-combinators,
  callPackage,
  lib,
}:
let
  generic = callPackage ./generic.nix;
in
lib.genAttrs
  [
    # FixMe(+completeness): enable when fixed upstream.
    # Issue: https://github.com/bonfire-networks/bonfire-app/issues/1737
    #"community"
    # FixMe(+completeness): generate deps.nix
    #"cooperation"
    #"coordination"
    "ember"
    "open_science"
    "social"
  ]
  (
    extension:
    let
      bonfire = generic {
        inherit bonfire;
        FLAVOUR = extension;
      };
    in
    bonfire
  )
