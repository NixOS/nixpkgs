# Minimal manual prototype

{ pkgs ? (import ../. {}), nixpkgs ? { }} :

with pkgs;

stdenvNoCC.mkDerivation rec {
  name = "nixpkgs-minimal-manual";

  src = builtins.filterSource (path: type: type == "directory" || builtins.match ".*\.md" path == [] || builtins.match ".*\.dot" path == []) ./.;

  phases = [ "buildPhase" ];

  buildPhase = ''
    cp -r $src source
    chmod -R u+w source
    cp ${import ./doc-support/lib-functions-docs-cm.nix { inherit pkgs; }}/*.md source/functions/library/
    FONTCONFIG_FILE=${fontconfig.out}/etc/fonts/fonts.conf \
      ${graphviz}/bin/dot -Tsvg source/contributing/staging_workflow.dot > source/staging_workflow.svg
    ${mmdoc}/bin/mmdoc nixpkgs source $out
  '';
}
