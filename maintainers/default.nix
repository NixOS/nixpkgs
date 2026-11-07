/*
  Entry point for evaluation data from maintainer-list.nix:
  - normalise affiliation metadata
  - resolve maintainer fixpoint references
  - prevent infinite transitive reference cycles
*/
let
  inherit (builtins) mapAttrs;
  lib = import ../lib;
  dropAffiliation = lib.flip removeAttrs [ "affiliation" ];
  expandAffiliationData =
    maintainerBase: affiliationOverride:
    let
      fullData = dropAffiliation (maintainerBase // affiliationOverride);
    in
    fullData
    // lib.optionalAttrs (fullData ? fallbackMaintainers) {
      # drop affiliations from fallbackMaintainers to prevent transitive cycles
      fallbackMaintainers = map dropAffiliation fullData.fallbackMaintainers;
    };
in
{
  maintainer-list = mapAttrs (
    _: m:
    if m ? affiliation then
      m // { affiliation = mapAttrs (_: expandAffiliationData m) m.affiliation; }
    else
      m
  ) (lib.fix (self: import ./maintainer-list.nix { inherit self; }));
}
