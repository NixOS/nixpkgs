{ lib
, vscode-registry-commons
, overlays ? [ ]
}:

with vscode-registry-commons.registry-lib;

let

  ## The all-extension-raw.json is fetched from
  ## https://open-vsx.org/api/-/search?includeAllVersions=false&offset=0&size=2000
  ## The registry-reference-list.json is generated using
  ## jq -r '.extensions[] | [ .namespace, .name, .version] | @sh | "nix-prefetch-openvsx " + . + "; echo ,"' ./all-extensions-raw.json | xargs -I{} bash -c "{}" | tee -a registry-reference-list.json
  ## plus mamual corrections
  ## both are formatted using jq
  ## TODO: Automate the bootstrap and update
  ## API reference: https://open-vsx.org/swagger-ui/

  registry-reference-list-fetched =
    lib.importJSON ./registry-reference-list.json;

  base = final:
    {
      registry-reference-attrs-fetched = registryRefListToAttrs registry-reference-list-fetched;

      domain = "https://open-vsx.org";

      calcVsixUrl = (registry-reference@{ domain ? final.domain
                     , publisher
                     , name
                     , version
                     , ...
                     }:
        "${domain}/api/${publisher}/${name}/${version}/file/${publisher}.${name}-${version}.vsix");

      getVsixUrls = ref: [ (final.calcVsixUrl ref) ];

      registryRefAttrnames = [ "name" "publisher" "version" "sha256" ];

      meta-attrs = final.meta-attrs-fetched;

      urls-attrs = mapRegistryRefAttrs final.getVsixUrls final.registry-reference-attrs;
    };

  default-overlays = with vscode-registry-commons.modifiers; [
    cookrefs
    urls2vsix
    build
  ];

in
lib.fix (lib.foldl' (lib.flip lib.extends) base (default-overlays ++ overlays))
