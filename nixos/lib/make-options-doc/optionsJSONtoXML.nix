{ file }:

builtins.attrValues
  (builtins.mapAttrs
    (name: def: def // { inherit name; })
    (builtins.fromJSON (builtins.readFile file)))
