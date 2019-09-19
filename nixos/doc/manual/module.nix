{ pkgs, options, config, version, revision, extraSources ? [] }:

with pkgs;

let
  lib = pkgs.lib;

  # We need to strip references to /nix/store/* from options,
  # including any `extraSources` if some modules came from elsewhere,
  # or else the build will fail.
  #
  # E.g. if some `options` came from modules in ${pkgs.customModules}/nix,
  # you'd need to include `extraSources = [ pkgs.customModules ]`
  prefixesToStrip = map (p: "${toString p}/") ([ ../../.. ] ++ extraSources);
  stripAnyPrefixes = lib.flip (lib.fold lib.removePrefix) prefixesToStrip;

  optionsDoc = buildPackages.nixosOptionsDoc {
    inherit options revision;
    transformOptions = opt: opt // {
      # Clean up declaration sites to not refer to the NixOS source tree.
      declarations = map stripAnyPrefixes opt.declarations;
    };
  };

  sources = lib.sourceFilesBySuffices ./. [".nix" ".xml"];

  modulesDoc = builtins.toFile "modules.xml" ''
    <section xmlns:xi="http://www.w3.org/2001/XInclude" id="modules">
    ${(lib.concatMapStrings (path: ''
      <xi:include href="${path}" />
    '') (lib.catAttrs "value" config.meta.doc))}
    </section>
  '';

  generatedSources = runCommand "generated-docbook" {} ''
    mkdir $out
    ln -s ${modulesDoc} $out/modules.xml
    ln -s ${optionsDoc.optionsDocBook} $out/options-db.xml
    printf "%s" "${version}" > $out/nixos-version
  '';
in rec {
  inherit generatedSources;

  inherit (optionsDoc) optionsJSON optionsXML optionsDocBook;

  manual = pkgs.nix-doc-tools {
    name = "nixpkgs-manual";
    src = sources;
    generated-files = [
      generatedSources
    ];
  };

  manualHTML = manual;
  manualHTMLShell = pkgs.nix-doc-tools {
    name = "nixpkgs-manual";
    src = ./.;
    generated-files = [
      generatedSources
    ];
    nix-shell = true;
  };
}
