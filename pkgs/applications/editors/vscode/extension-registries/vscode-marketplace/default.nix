{ lib
, vscode-registry-commons
, callPackage
, overlays ? [ ]
}:

with vscode-registry-commons.registry-lib;

let

  registry-reference-list-fetched = lib.importJSON ./registry-reference-list.json;

  base = final:
    {
      calcVsixUrl =
        registry-reference@{ publisher, name, version, ... }:
        "https://${publisher}.gallery.vsassets.io/_apis/public/gallery/publisher/${publisher}/extension/${name}/${version}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage";

      getVsixUrls = ref: [ (final.calcVsixUrl ref) ];

      urls-attrs = mapRegistryRefAttrs final.getVsixUrls final.registry-reference-attrs;

      registry-reference-attrNames = [ "publisher" "name" "version" "sha256" ];

      registry-reference-attrs-fetched = registryRefListToAttrs registry-reference-list-fetched;

      meta-attrs = final.meta-attrs-fetched;
    };

  default-overlays = with vscode-registry-commons.modifiers; [
    cookrefs
    urls2vsix
    build
  ];
in
lib.fix (lib.foldl' (lib.flip lib.extends) base (default-overlays ++ overlays))
