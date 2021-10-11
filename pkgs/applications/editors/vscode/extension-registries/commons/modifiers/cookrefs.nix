{ lib
, vscode-registry-commons
}:

/*
  Turn the fetched registry reference data
  to registry-reference-attrs and meta-attrs-fetched.

  Order-independent

  Main inputs:
  - registry-reference-attrs-fetched

  Main outputs:
  - registry-reference-attrs
  - meta-attrs-fetched
*/

with vscode-registry-commons.registry-lib;

let
  getLicenseFromSpdxId = licstr:
    lib.getLicenseFromSpdxId' licstr (
      if lib.toUpper licstr == "UNLICENSED"
      then lib.licenses.unfree
      else null
    );
in
final: prev:

{
  registry-reference-attrs = (mapRegistryRefAttrs (lib.getAttrs final.registryRefAttrnames)
    final.registry-reference-attrs-fetched);

  meta-attrs-fetched = mapRegistryRefAttrs
    (ref:
      (getExistingAttrs [ "description" "homepage" ] ref)
      // (
        let
          license = getLicenseFromSpdxId ref.license-raw;
        in
        lib.optionalAttrs (builtins.hasAttr "license-raw" ref && license != null) {
          inherit license;
        }
      ))
    final.registry-reference-attrs-fetched;
}
