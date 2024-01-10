{ pkgs, nixpkgs ? { }, libsets }:
let
  revision = pkgs.lib.trivial.revisionWithDefault (nixpkgs.rev or "master");

  libDefPos = prefix: set:
    builtins.concatMap
      (name: [{
        name = builtins.concatStringsSep "." (prefix ++ [name]);
        location = builtins.unsafeGetAttrPos name set;
      }] ++ nixpkgsLib.optionals
        (builtins.length prefix == 0 && builtins.isAttrs set.${name})
        (libDefPos (prefix ++ [name]) set.${name})
      ) (builtins.attrNames set);

  libset = toplib:
    builtins.map
      (subsetname: {
        subsetname = subsetname;
        functions = libDefPos [] toplib.${subsetname};
      })
      (builtins.map (x: x.name) libsets);

  nixpkgsLib = pkgs.lib;

  flattenedLibSubset = { subsetname, functions }:
  builtins.map
    (fn: {
      name = "lib.${subsetname}.${fn.name}";
      value = fn.location;
    })
    functions;

  locatedlibsets = libs: builtins.map flattenedLibSubset (libset libs);
  removeFilenamePrefix = prefix: filename:
    let
    prefixLen = (builtins.stringLength prefix) + 1; # +1 to remove the leading /
      filenameLen = builtins.stringLength filename;
      substr = builtins.substring prefixLen filenameLen filename;
      in substr;

  removeNixpkgs = removeFilenamePrefix (builtins.toString pkgs.path);

  liblocations =
    builtins.filter
      (elem: elem.value != null)
      (nixpkgsLib.lists.flatten
        (locatedlibsets nixpkgsLib));

  fnLocationRelative = { name, value }:
    {
      inherit name;
      value = value // { file = removeNixpkgs value.file; };
    };

  relativeLocs = (builtins.map fnLocationRelative liblocations);
  sanitizeId = builtins.replaceStrings
    [ "'"      ]
    [ "-prime" ];

  urlPrefix = "https://github.com/NixOS/nixpkgs/blob/${revision}";
  jsonLocs = builtins.listToAttrs
    (builtins.map
      ({ name, value }: {
        name = sanitizeId name;
        value =
          let
            text = "${value.file}:${builtins.toString value.line}";
            target = "${urlPrefix}/${value.file}#L${builtins.toString value.line}";
          in
            "[${text}](${target}) in `<nixpkgs>`";
      })
    relativeLocs);

in
pkgs.writeText "locations.json" (builtins.toJSON jsonLocs)
