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
    name = "nixos-manual";
    src = ./manual;
    generated-files = [
      generatedSources
    ];
    olinks = {
      # self-referential, as the generated options uses olinks. This
      # is because the generated options also appear in man pages,
      # and *that* doc set must use olinks.
      #
      # note: nix-doc-tools internally uses a passthru, so this isn't
      #       actually an infinite loop.
      manual = manual;
    };
  };

  manualHTML = manual;
  manualHTMLIndex = "${manualHTML}/share/doc/nixos/index.html";
  manualHTMLShell = pkgs.nix-doc-tools {
    name = "nixos-manual";
    src = ./manual;
    generated-files = [
      generatedSources
    ];
    nix-shell = true;
  };

  manpages = pkgs.nix-doc-tools {
    name = "nixos-man-pages";
    root-file-name = "man-pages.xml";
    combined-file-name = "man-pages-combined.xml";
    src = ./man-pages;
    generated-files = [
      generatedSources
    ];
    olinks = {
      manual = manual;
    };
  };
  manpagesShell = pkgs.nix-doc-tools {
    name = "nixos-man-pages";
    root-file-name = "man-pages.xml";
    combined-file-name = "man-pages-combined.xml";
    src = ./man-pages;
    generated-files = [
      generatedSources
    ];
    nix-shell = true;
  };
}
