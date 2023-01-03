{ pkgs, nixpkgs ? { }, libsets }:
let
  revision = pkgs.lib.trivial.revisionWithDefault (nixpkgs.revision or "master");

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
  xmlstrings = (nixpkgsLib.strings.concatMapStrings
      ({ name, value }:
      ''
      <section><title>${name}</title>
        <para xml:id="${sanitizeId name}">
        Located at
        <link
          xlink:href="${urlPrefix}/${value.file}#L${builtins.toString value.line}">${value.file}:${builtins.toString value.line}</link>
        in  <literal>&lt;nixpkgs&gt;</literal>.
        </para>
        </section>
      '')
      relativeLocs);

in pkgs.writeText
    "locations.xml"
    ''
    <section xmlns="http://docbook.org/ns/docbook"
         xmlns:xlink="http://www.w3.org/1999/xlink"
         version="5">
         <title>All the locations for every lib function</title>
         <para>This file is only for inclusion by other files.</para>
         ${xmlstrings}
    </section>
    ''
