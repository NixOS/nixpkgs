# This file describes the Nixpkgs manual, which happens to use module docs infra originally
# developed for NixOS. To build this derivation, run `nix-build -A nixpkgs-manual`.
#
{
  lib,
  stdenvNoCC,
  callPackage,
  devmode,
  mkShellNoCC,
  documentation-highlighter,
  nixos-render-docs,
  nixos-render-docs-redirects,
  writeShellScriptBin,
  nixpkgs ? { },
  markdown-code-runner,
  roboto,
  treefmt,
  nixosOptionsDoc,
}:
stdenvNoCC.mkDerivation (
  finalAttrs:
  let
    inherit (finalAttrs.finalPackage.optionsDoc) optionsJSON;
    inherit (finalAttrs.finalPackage) epub lib-docs pythonInterpreterTable;

    # Make anything from lib (the module system internals) invisible
    hide-lib =
      opt:
      opt
      // {
        visible = if lib.all (decl: decl == "lib/modules.nix") opt.declarations then false else opt.visible;
      };

    toURL =
      decl:
      let
        declStr = toString decl;
        root = toString (../..);
        subpath = lib.removePrefix "/" (lib.removePrefix root declStr);
      in
      if lib.hasPrefix root declStr then
        {
          url = "https://github.com/NixOS/nixpkgs/blob/master/${subpath}";
          name = "nixpkgs/${subpath}";
        }
      else
        decl;

    mapURLs = opt: opt // { declarations = map toURL opt.declarations; };

    docs.generic.meta-maintainers = nixosOptionsDoc {
      inherit (lib.evalModules { modules = [ ../../modules/generic/meta-maintainers.nix ]; }) options;
      transformOptions = opt: hide-lib (mapURLs opt);
    };
  in
  {
    name = "nixpkgs-manual";

    nativeBuildInputs = [ nixos-render-docs ];

    src = lib.cleanSourceWith {
      src = ../.;
      filter =
        path: type:
        type == "directory"
        || lib.hasSuffix ".md" path
        || lib.hasSuffix ".md.in" path
        || lib.elem path (
          map toString [
            ../style.css
            ../anchor-use.js
            ../anchor.min.js
            ../manpage-urls.json
            ../redirects.json
          ]
        );
    };

    postPatch = ''
      ln -s ${optionsJSON}/share/doc/nixos/options.json ./config-options.json
      ln -s ${treefmt.functionsDoc.markdown} ./packages/treefmt-functions.section.md
      ln -s ${treefmt.optionsDoc.optionsJSON}/share/doc/nixos/options.json ./treefmt-options.json
      ln -s ${docs.generic.meta-maintainers.optionsJSON}/share/doc/nixos/options.json ./options-modules-generic-meta-maintainers.json
    '';

    buildPhase = ''
      runHook preBuild

      substituteInPlace ./languages-frameworks/python.section.md \
        --subst-var-by python-interpreter-table "$(<"${pythonInterpreterTable}")"

      cat ./functions/library.md.in ${lib-docs}/index.md > ./functions/library.md

      substitute ./manual.md.in ./manual.md \
        --replace-fail '@MANUAL_VERSION@' '${lib.version}'

      mkdir -p out/media

      mkdir -p out/highlightjs
      cp -t out/highlightjs \
        ${documentation-highlighter}/highlight.pack.js \
        ${documentation-highlighter}/LICENSE \
        ${documentation-highlighter}/mono-blue.css \
        ${documentation-highlighter}/loader.js

      cp -t out ./style.css ./anchor.min.js ./anchor-use.js

      nixos-render-docs manual html \
        --manpage-urls ./manpage-urls.json \
        --redirects ./redirects.json \
        --revision ${nixpkgs.rev or "master"} \
        --stylesheet style.css \
        --stylesheet highlightjs/mono-blue.css \
        --script ./highlightjs/highlight.pack.js \
        --script ./highlightjs/loader.js \
        --script ./anchor.min.js \
        --script ./anchor-use.js \
        --toc-depth 1 \
        --section-toc-depth 1 \
        manual.md \
        out/index.html

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      dest="$out/share/doc/nixpkgs"
      mkdir -p "$(dirname "$dest")"
      mv out "$dest"
      cp "$dest/index.html" "$dest/manual.html"

      cp ${roboto.src}/web/Roboto\[ital\,wdth\,wght\].ttf "$dest/Roboto.ttf"

      cp ${epub} "$dest/nixpkgs-manual.epub"

      mkdir -p $out/nix-support/
      echo "doc manual $dest index.html" >> $out/nix-support/hydra-build-products
      echo "doc manual $dest nixpkgs-manual.epub" >> $out/nix-support/hydra-build-products

      runHook postInstall
    '';

    passthru = {
      lib-docs = callPackage ./lib-function-docs.nix { inherit nixpkgs; };

      epub = callPackage ./epub.nix { };

      optionsDoc = callPackage ./options-doc.nix { };

      pythonInterpreterTable = callPackage ./python-interpreter-table.nix { };

      shell =
        let
          devmode' = devmode.override {
            buildArgs = toString ../.;
            open = "/share/doc/nixpkgs/index.html";
          };
          nixos-render-docs-redirects' = writeShellScriptBin "redirects" "${lib.getExe nixos-render-docs-redirects} --file ${toString ../redirects.json} $@";
        in
        mkShellNoCC {
          packages = [
            devmode'
            nixos-render-docs-redirects'
            markdown-code-runner
          ];
        };

      tests = {
        manpage-urls = callPackage ../tests/manpage-urls.nix { };
      };
    };
  }
)
