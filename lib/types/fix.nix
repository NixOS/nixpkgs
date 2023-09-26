{ lib }:

let
  inherit (lib) toFunction mkOptionType
    optionDescriptionPhrase isFunction mergeDefinitions defaultFunctor;

  # TODO: should this be a type or a "property"? (i.e. one of `mkIf`, `mkMerge`, etc)
  fix = t: mkOptionType {
    name = "fixpoint of ${t.name}";
    description = t.description;
    descriptionClass = "composite";
    check = v: isFunction v || t.check v;
    merge = loc: defs:
      let
        # TODO: facilities elsewhere for wiring `options` and/or other "meta" info into this.
        args = { value = r; };
        r = (mergeDefinitions loc t (map (fn: { inherit (fn) file; value = toFunction fn.value args; }) defs)).mergedValue;
      in r;
    getSubOptions = prefix: t.getSubOptions prefix;
    getSubModules = t.getSubModules;
    substSubModules = m: fix (t.substSubModules m);
    functor = defaultFunctor "fix" // { inherit t; };
    nestedTypes.t = t;
  };

in
{
  inherit fix;
}
