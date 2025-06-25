lib:

with lib;

rec {
  paramsToConf = cfg: ps: mkConf 0 (paramsToRenderedStrings cfg ps);

  # mkConf takes an indentation level (which usually starts at 0) and a nested
  # attribute set of strings and will render that set to a strongswan.conf style
  # configuration format. For example:
  #
  #   mkConf 0 {a = "1"; b = { c = { "foo" = "2"; "bar" = "3"; }; d = "4";};}   =>   ''
  #   a = 1
  #   b {
  #     c {
  #       foo = 2
  #       bar = 3
  #     }
  #     d = 4
  #   }''
  mkConf =
    indent: ps:
    concatMapStringsSep "\n" (
      name:
      let
        value = ps.${name};
        indentation = replicate indent " ";
      in
      indentation
      + (
        if isAttrs value then
          "${name} {\n" + mkConf (indent + 2) value + "\n" + indentation + "}"
        else
          "${name} = ${value}"
      )
    ) (attrNames ps);

  replicate = n: c: concatStrings (builtins.genList (_x: c) n);

  # `paramsToRenderedStrings cfg ps` converts the NixOS configuration `cfg`
  # (typically the "config" argument of a NixOS module) and the set of
  # parameters `ps` (an attribute set where the values are constructed using the
  # parameter constructors in ./param-constructors.nix) to a nested attribute
  # set of strings (rendered parameters).
  paramsToRenderedStrings =
    cfg: ps:
    filterEmptySets (
      (mapParamsRecursive (
        path: name: param:
        let
          value = attrByPath path null cfg;
        in
        optionalAttrs (value != null) (param.render name value)
      ) ps)
    );

  filterEmptySets =
    set:
    filterAttrs (n: v: (v != null)) (
      mapAttrs (
        name: value:
        if isAttrs value then
          let
            value' = filterEmptySets value;
          in
          if value' == { } then null else value'
        else
          value
      ) set
    );

  # Recursively map over every parameter in the given attribute set.
  mapParamsRecursive = mapAttrsRecursiveCond' (as: (!(as ? _type && as._type == "param")));

  mapAttrsRecursiveCond' =
    cond: f: set:
    let
      recurse =
        path: set:
        let
          g =
            name: value:
            if isAttrs value && cond value then
              { ${name} = recurse (path ++ [ name ]) value; }
            else
              f (path ++ [ name ]) name value;
        in
        mapAttrs'' g set;
    in
    recurse [ ] set;

  mapAttrs'' = f: set: foldl' (a: b: a // b) { } (mapAttrsToList f set);

  # Extract the options from the given set of parameters.
  paramsToOptions = ps: mapParamsRecursive (_path: name: param: { ${name} = param.option; }) ps;

}
