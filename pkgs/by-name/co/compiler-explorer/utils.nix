{ lib
, symlinkJoin
, writeTextDir
}:

rec {
  attrToDot =
    let
      attrToDotHelper = prefix: x:
        lib.concatStrings
          (lib.mapAttrsToList
            (k: v:
              if builtins.elem (builtins.typeOf v) [ "string" "int" "float" ]
              then "${prefix}${k}=${toString v}\n"
              else attrToDotHelper "${prefix}${k}." v)
            x);
    in
    attrToDotHelper "";

  /** Constructs configuration files from a config attrset.
      Within this attrset, each key will create a new properties file
      at "etc/config/<key>.nix.properties" */
  makeConfigs = configs: symlinkJoin {
    name = "compiler-explorer-etc-config";
    paths =
      lib.mapAttrsToList
        (k: v: writeTextDir
          "config/${k}.nix.properties"
          (attrToDot v))
        configs;
  };

}
