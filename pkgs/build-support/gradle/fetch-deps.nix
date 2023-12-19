{ mitm-cache
, lib
}:

{ data, pname ? throw "Please pass pname to fetchDeps", name ? "${pname}-deps", ... } @ attrs:

let
  data' = if builtins.isPath data then builtins.fromJSON (builtins.readFile data) else data;
  visitAttrs = prefix: attrs: builtins.foldl' (a: b: a // b) {} (lib.mapAttrsToList (visit prefix) attrs);
  visit = prefix: k: v:
    if builtins.isAttrs v
    then visitAttrs (prefix ++ [k]) v
    else let
      splitHash = lib.splitString "#" (builtins.concatStringsSep "/" prefix);
      nameVer = builtins.match "(.*/)?(.*)/(.*)" (lib.last splitHash);
      init = toString (builtins.head nameVer);
      name = builtins.elemAt nameVer 1;
      ver = builtins.elemAt nameVer 2;
      prefix' =
        if builtins.length splitHash == 1 then builtins.head splitHash
        else builtins.concatStringsSep "/${name}/${ver}/" (lib.init splitHash ++ [ "${init}${name}-${ver}" ]);
    in {
      "${prefix'}.${k}" =
        (if lib.hasSuffix "=" v then { sha256 = v; }
        else if lib.hasPrefix "http" v then { redirect = v; }
        else { text = v; });
    };
in
  mitm-cache.fetch (builtins.removeAttrs attrs [ "pname" ] // {
    inherit name;
    data = visitAttrs [] data';
  })
