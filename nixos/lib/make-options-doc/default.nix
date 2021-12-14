/* Generate JSON, XML and DocBook documentation for given NixOS options.

   Minimal example:

    { pkgs,  }:

    let
      eval = import (pkgs.path + "/nixos/lib/eval-config.nix") {
        baseModules = [
          ../module.nix
        ];
        modules = [];
      };
    in pkgs.nixosOptionsDoc {
      options = eval.options;
    }

*/
{ pkgs
, lib
, options
, transformOptions ? lib.id  # function for additional tranformations of the options
, revision ? "" # Specify revision for the options
}:

let
  # Make a value safe for JSON. Functions are replaced by the string "<function>",
  # derivations are replaced with an attrset
  # { _type = "derivation"; name = <name of that derivation>; }.
  # We need to handle derivations specially because consumers want to know about them,
  # but we can't easily use the type,name subset of keys (since type is often used as
  # a module option and might cause confusion). Use _type,name instead to the same
  # effect, since _type is already used by the module system.
  substSpecial = x:
    if lib.isDerivation x then { _type = "derivation"; name = x.name; }
    else if builtins.isAttrs x then lib.mapAttrs (name: substSpecial) x
    else if builtins.isList x then map substSpecial x
    else if lib.isFunction x then "<function>"
    else x;

  optionsList = lib.flip map optionsListVisible
   (opt: transformOptions opt
    // lib.optionalAttrs (opt ? example) { example = substSpecial opt.example; }
    // lib.optionalAttrs (opt ? default) { default = substSpecial opt.default; }
    // lib.optionalAttrs (opt ? type) { type = substSpecial opt.type; }
    // lib.optionalAttrs (opt ? relatedPackages && opt.relatedPackages != []) { relatedPackages = genRelatedPackages opt.relatedPackages opt.name; }
   );

  # Generate DocBook documentation for a list of packages. This is
  # what `relatedPackages` option of `mkOption` from
  # ../../../lib/options.nix influences.
  #
  # Each element of `relatedPackages` can be either
  # - a string:  that will be interpreted as an attribute name from `pkgs`,
  # - a list:    that will be interpreted as an attribute path from `pkgs`,
  # - an attrset: that can specify `name`, `path`, `package`, `comment`
  #   (either of `name`, `path` is required, the rest are optional).
  genRelatedPackages = packages: optName:
    let
      unpack = p: if lib.isString p then { name = p; }
                  else if lib.isList p then { path = p; }
                  else p;
      describe = args:
        let
          title = args.title or null;
          name = args.name or (lib.concatStringsSep "." args.path);
          path = args.path or [ args.name ];
          package = args.package or (lib.attrByPath path (throw "Invalid package attribute path `${toString path}' found while evaluating `relatedPackages' of option `${optName}'") pkgs);
        in "<listitem>"
        + "<para><literal>${lib.optionalString (title != null) "${title} aka "}pkgs.${name} (${package.meta.name})</literal>"
        + lib.optionalString (!package.meta.available) " <emphasis>[UNAVAILABLE]</emphasis>"
        + ": ${package.meta.description or "???"}.</para>"
        + lib.optionalString (args ? comment) "\n<para>${args.comment}</para>"
        # Lots of `longDescription's break DocBook, so we just wrap them into <programlisting>
        + lib.optionalString (package.meta ? longDescription) "\n<programlisting>${package.meta.longDescription}</programlisting>"
        + "</listitem>";
    in "<itemizedlist>${lib.concatStringsSep "\n" (map (p: describe (unpack p)) packages)}</itemizedlist>";

  # Remove invisible and internal options.
  optionsListVisible = lib.filter (opt: opt.visible && !opt.internal) (lib.optionAttrSetToDocList options);

  optionsNix = builtins.listToAttrs (map (o: { name = o.name; value = removeAttrs o ["name" "visible" "internal"]; }) optionsList);

in rec {
  inherit optionsNix;

  optionsAsciiDoc = pkgs.runCommand "options.adoc" {} ''
    ${pkgs.python3Minimal}/bin/python ${./generateAsciiDoc.py} \
      < ${optionsJSON}/share/doc/nixos/options.json \
      > $out
  '';

  optionsCommonMark = pkgs.runCommand "options.md" {} ''
    ${pkgs.python3Minimal}/bin/python ${./generateCommonMark.py} \
      < ${optionsJSON}/share/doc/nixos/options.json \
      > $out
  '';

  optionsJSON = pkgs.runCommand "options.json"
    { meta.description = "List of NixOS options in JSON format";
      buildInputs = [ pkgs.brotli ];
    }
    ''
      # Export list of options in different format.
      dst=$out/share/doc/nixos
      mkdir -p $dst

      cp ${builtins.toFile "options.json" (builtins.unsafeDiscardStringContext (builtins.toJSON optionsNix))} $dst/options.json

      brotli -9 < $dst/options.json > $dst/options.json.br

      mkdir -p $out/nix-support
      echo "file json $dst/options.json" >> $out/nix-support/hydra-build-products
      echo "file json-br $dst/options.json.br" >> $out/nix-support/hydra-build-products
    '';

  # Convert options.json into an XML file.
  # The actual generation of the xml file is done in nix purely for the convenience
  # of not having to generate the xml some other way
  optionsXML = pkgs.runCommand "options.xml" {} ''
    export NIX_STORE_DIR=$TMPDIR/store
    export NIX_STATE_DIR=$TMPDIR/state
    ${pkgs.nix}/bin/nix-instantiate \
      --eval --xml --strict ${./optionsJSONtoXML.nix} \
      --argstr file ${optionsJSON}/share/doc/nixos/options.json \
      > "$out"
  '';

  optionsDocBook = pkgs.runCommand "options-docbook.xml" {} ''
    optionsXML=${optionsXML}
    if grep /nixpkgs/nixos/modules $optionsXML; then
      echo "The manual appears to depend on the location of Nixpkgs, which is bad"
      echo "since this prevents sharing via the NixOS channel.  This is typically"
      echo "caused by an option default that refers to a relative path (see above"
      echo "for hints about the offending path)."
      exit 1
    fi

    ${pkgs.python3Minimal}/bin/python ${./sortXML.py} $optionsXML sorted.xml
    ${pkgs.libxslt.bin}/bin/xsltproc \
      --stringparam revision '${revision}' \
      -o intermediate.xml ${./options-to-docbook.xsl} sorted.xml
    ${pkgs.libxslt.bin}/bin/xsltproc \
      -o "$out" ${./postprocess-option-descriptions.xsl} intermediate.xml
  '';
}
