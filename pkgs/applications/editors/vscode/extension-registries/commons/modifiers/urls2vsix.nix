{ lib, vscode-registry-commons, fetchurl }:

/* Map urls-attrs to vsix-attrs

  Order-independent

  Main outputs
  - vsix-attrs

  Main inputs
  - registry-reference-attrs
  - urls-attrs
*/

final: prev:

with vscode-registry-commons.registry-lib;

{
  registryRefAttrnames = uniquelyUnionLists (prev.registryRefAttrnames or [ ]) [ "name" "publisher" "version" "sha256" ];

  vsix-attrs = mapRegistryRefAttrs
    (ref:
      fetchurl {
        name = "${ref.publisher}.${ref.name}-${ref.version}.vsix";
        urls = final.urls-attrs.${escapeAttrPrefix ref.publisher}.${escapeAttrPrefix ref.name};
        inherit (ref) sha256;
      }
    )
    final.registry-reference-attrs;
}
