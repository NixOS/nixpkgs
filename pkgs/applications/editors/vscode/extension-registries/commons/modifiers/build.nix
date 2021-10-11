{ lib, fetchurl, vscode-registry-commons }:

/* Provide the build result

  Order-independent

  Main outputs
  - extensions
  - mkExtensionFromRef

  Main inputs
  - registry-reference-attrs
  - meta-attrs ? { }
  - vsix-attrs
  - make-extension-attrs ? { }
*/

with vscode-registry-commons.registry-lib;

final: prev:

{

  meta-attrs = prev.meta-attrs or { };

  make-extension-attrs = prev.make-extension-attrs or { };

  registryRefAttrnames = uniquelyUnionLists (prev.registryRefAttrnames or [ ]) [ "name" "publisher" "version" ];

  inherit (vscode-registry-commons) mkExtensionGeneral;

  mkExtensionFromRefSimple = registryRef:
    let
      builder =
        if (lib.hasAttrByPath [ (escapeAttrPrefix registryRef.publisher) (escapeAttrPrefix registryRef.name) ] final.make-extension-attrs)
        then final.make-extension-attrs."${escapeAttrPrefix registryRef.publisher}"."${escapeAttrPrefix registryRef.name}"
        else final.mkExtensionGeneral;
    in
    builder {
      inherit registryRef;
      vsix = final.vsix-attrs."${escapeAttrPrefix registryRef.publisher}".${escapeAttrPrefix registryRef.name};
      meta = final.meta-attrs."${escapeAttrPrefix registryRef.publisher}"."${escapeAttrPrefix registryRef.name}";
    };

  extensions = recurseIntoExtensionAttrs (mapRegistryRefAttrs final.mkExtensionFromRefSimple final.registry-reference-attrs);

  mkExtensionFromRef = registryRef: (
    final.mkExtensionFromRefSimple
      (lib.getAttrs final.registryRefAttrnames registryRef)
  ).override
    (removeAttrs final.registryRefAttrnames registryRef);
}
