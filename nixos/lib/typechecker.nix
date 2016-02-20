{ config, lib, pkgs, baseModules, ... }:

with pkgs;
with pkgs.lib;

let

  optionsSpecs = inferenceMode:
    let
      versionModule =
        { system.nixosVersionSuffix = config.system.nixosVersionSuffix;
          system.nixosRevision = config.system.nixosRevision;
          nixpkgs.system = config.nixpkgs.system;
        };

      internalModule = { _module = config._module; } // (if isNull inferenceMode then {} else { _module.typeInference = mkForce inferenceMode; });

      eval = evalModules {
        modules = [ versionModule ] ++ baseModules ++ [ internalModule ];
        args = (config._module.args) // { modules = [ ]; };
      };

      # Remove invisible and internal options.
      optionsSpecs' = filter (opt: opt.visible && !opt.internal) (optionAttrSetToParseableSpecifications config._module eval.options);

      # INFO: Please add 'defaultText' or 'literalExample' to the option
      #       definition to avoid this exception!
      substFunction = key: decls: x:
        if builtins.isAttrs x then mapAttrs (name: substFunction key decls) x
        else if builtins.isList x then map (substFunction key decls) x
        else if builtins.isFunction x then throw "Found an unexpected <function> in ${key} declared in ${concatStringsSep " and " decls}."
        else x;

      prefix = toString ../..;

      stripPrefix = fn:
        if substring 0 (stringLength prefix) fn == prefix then
          substring (stringLength prefix + 1) 1000 fn
        else
          fn;

      # Clean up declaration sites to not refer to the NixOS source tree.
      cleanupOptions = x: flip map x (opt:
        let substFunction' = y: substFunction opt.name opt.declarations y;
        in opt
           // { declarations = map (fn: stripPrefix fn) opt.declarations; }
           // optionalAttrs (opt ? example) { example = substFunction' opt.example; }
           // optionalAttrs (opt ? default) { default = substFunction' opt.default; }
           // optionalAttrs (opt ? type) { type = substFunction' opt.type; });

    in
      cleanupOptions optionsSpecs';

in

{

  system.build.typechecker = {

    # The NixOS options as machine readable specifications in JSON format.
    specifications = stdenv.mkDerivation {
      name = "options-specs-json";

      buildCommand = ''
        # Export list of options in different format.
        dst=$out/share/doc/nixos
        mkdir -p $dst

        cp ${builtins.toFile "options.json" (builtins.unsafeDiscardStringContext (builtins.toJSON
          (listToAttrs (map (o: { name = o.name; value = removeAttrs o ["name" "visible" "internal"]; }) (optionsSpecs null)))))
        } $dst/options-specs.json

        mkdir -p $out/nix-support
        echo "file json $dst/options-specs.json" >> $out/nix-support/hydra-build-products
      ''; # */

      meta.description = "List of NixOS options specifications in JSON format";
    };

    silent = listToAttrs (map (o: { name = o.name; value = removeAttrs o ["name" "visible" "internal"]; }) (optionsSpecs "silent"));
    printAll = listToAttrs (map (o: { name = o.name; value = removeAttrs o ["name" "visible" "internal"]; }) (optionsSpecs "printAll"));
    printUnspecified = listToAttrs (map (o: { name = o.name; value = removeAttrs o ["name" "visible" "internal"]; }) (optionsSpecs "printUnspecified"));

  };

}





