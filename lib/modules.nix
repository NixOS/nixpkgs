with import ./.. {};
with lib;

rec {

  /* Evaluate a set of modules.  The result is a set of two
     attributes: ‘options’: the nested set of all option declarations,
     and ‘config’: the nested set of all option values. */
  evalModules = modules: args:
    let
      args' = args // result;
      closed = closeModules modules args';
      # Note: the list of modules is reversed to maintain backward
      # compatibility with the old module system.  Not sure if this is
      # the most sensible policy.
      options = mergeModules (reverseList closed);
      config = yieldConfig options;
      yieldConfig = mapAttrs (n: v: if isOption v then v.value else yieldConfig v);
      result = { inherit options config; };
    in result;

  /* Close a set of modules under the ‘imports’ relation. */
  closeModules = modules: args:
    let
      coerceToModule = n: x:
        if isAttrs x || builtins.isFunction x then
          unifyModuleSyntax "anon-${toString n}" (applyIfFunction x args)
        else
          unifyModuleSyntax (toString x) (applyIfFunction (import x) args);
      toClosureList = imap (path: coerceToModule path);
    in
      builtins.genericClosure {
        startSet = toClosureList modules;
        operator = m: toClosureList m.imports;
      };

  /* Massage a module into canonical form, that is, a set consisting
     of ‘options’, ‘config’ and ‘imports’ attributes. */
  unifyModuleSyntax = key: m:
    if m ? config || m ? options || m ? imports then
      let badAttrs = removeAttrs m ["imports" "options" "config"]; in
      if badAttrs != {} then
        throw "Module `${key}' has an unsupported attribute `${head (attrNames badAttrs)}'. ${builtins.toXML m} "
      else
        { inherit key;
          imports = m.imports or [];
          options = m.options or {};
          config = m.config or {};
        }
    else
      { inherit key;
        imports = m.require or [];
        options = {};
        config = m;
      };

  applyIfFunction = f: arg: if builtins.isFunction f then f arg else f;

  /* Merge a list of modules.  This will recurse over the option
     declarations in all modules, combining them into a single set.
     At the same time, for each option declaration, it will merge the
     corresponding option definitions in all machines, returning them
     in the ‘value’ attribute of each option. */
  mergeModules = modules:
    mergeModules' [] (map (m: m.options) modules) (concatMap (m: pushDownProperties m.config) modules);

  mergeModules' = loc: options: configs:
    zipAttrsWith (name: vals:
      let loc' = loc ++ [name]; in
      if all isOption vals then
        let opt = fixupOptionType loc' (mergeOptionDecls loc' vals);
        in evalOptionValue loc' opt (catAttrs name configs)
      else if any isOption vals then
        throw "There are options with the prefix `${showOption loc'}', which is itself an option."
      else
        mergeModules' loc' vals (concatMap pushDownProperties (catAttrs name configs))
    ) options;

  /* Merge multiple option declarations into a single declaration.  In
     general, there should be only one declaration of each option.
     The exception is the ‘options’ attribute, which specifies
     sub-options.  These can be specified multiple times to allow one
     module to add sub-options to an option declared somewhere else
     (e.g. multiple modules define sub-options for ‘fileSystems’). */
  mergeOptionDecls = loc: opts:
    fold (opt1: opt2:
      if opt1 ? default && opt2 ? default ||
         opt1 ? example && opt2 ? example ||
         opt1 ? description && opt2 ? description ||
         opt1 ? merge && opt2 ? merge ||
         opt1 ? apply && opt2 ? apply ||
         opt1 ? type && opt2 ? type
      then
        throw "Conflicting declarations of the option `${showOption loc}'."
      else
        opt1 // opt2
          // optionalAttrs (opt1 ? options && opt2 ? options)
            { options = [ opt1.options opt2.options ]; }
    ) {} opts;

  /* Merge all the definitions of an option to produce the final
     config value. */
  evalOptionValue = loc: opt: defs:
    let
      # Process mkMerge and mkIf properties.
      defs' = concatMap dischargeProperties defs;
      # Process mkOverride properties, adding in the default
      # value specified in the option declaration (if any).
      defsFinal = filterOverrides (optional (opt ? default) (mkOptionDefault opt.default) ++ defs');
      # Type-check the remaining definitions, and merge them
      # if possible.
      merged =
        if defsFinal == [] then
          throw "The option `${showOption loc}' is used but not defined."
        else
          if all opt.type.check defsFinal then
            opt.type.merge defsFinal
            #throw "The option `${showOption loc}' has multiple values (with no way to merge them)."
          else
            throw "A value of the option `${showOption loc}' has a bad type.";
      # Finally, apply the ‘apply’ function to the merged
      # value.  This allows options to yield a value computed
      # from the definitions.
      value = (opt.apply or id) merged;
    in opt //
      { inherit value;
        definitions = defsFinal;
        isDefined = defsFinal != [];
      };

  /* Given a config set, expand mkMerge properties, and push down the
     mkIf properties into the children.  The result is a list of
     config sets that do not have properties at top-level.  For
     example,

       mkMerge [ { boot = set1; } (mkIf cond { boot = set2; services = set3; }) ]

     is transformed into

       [ { boot = set1; } { boot = mkIf cond set2; services mkIf cond set3; } ].

     This transform is the critical step that allows mkIf conditions
     to refer to the full configuration without creating an infinite
     recursion.
  */
  pushDownProperties = cfg:
    if cfg._type or "" == "merge" then
      concatMap pushDownProperties cfg.contents
    else if cfg._type or "" == "if" then
      map (mapAttrs (n: v: mkIf cfg.condition v)) (pushDownProperties cfg.content)
    else
      # FIXME: handle mkOverride?
      [ cfg ];

  /* Given a config value, expand mkMerge properties, and discharge
     any mkIf conditions.  That is, this is the place where mkIf
     conditions are actually evaluated.  The result is a list of
     config values.  For example, ‘mkIf false x’ yields ‘[]’,
     ‘mkIf true x’ yields ‘[x]’, and

       mkMerge [ 1 (mkIf true 2) (mkIf true (mkIf false 3)) ]

     yields ‘[ 1 2 ]’.
  */
  dischargeProperties = def:
    if def._type or "" == "merge" then
      concatMap dischargeProperties def.contents
    else if def._type or "" == "if" then
      if def.condition then
        dischargeProperties def.content
      else
        [ ]
    else
      [ def ];

  /* Given a list of config value, process the mkOverride properties,
     that is, return the values that have the highest (that
     is,. numerically lowest) priority, and strip the mkOverride
     properties.  For example,

       [ (mkOverride 10 "a") (mkOverride 20 "b") "z" (mkOverride 10 "d")  ]

     yields ‘[ "a" "d" ]’.  Note that "z" has the default priority 100.
  */
  filterOverrides = defs:
    let
      defaultPrio = 100;
      getPrio = def: if def._type or "" == "override" then def.priority else defaultPrio;
      min = x: y: if x < y then x else y;
      highestPrio = fold (def: prio: min (getPrio def) prio) 9999 defs;
      strip = def: if def._type or "" == "override" then def.content else def;
    in concatMap (def: if getPrio def == highestPrio then [(strip def)] else []) defs;

  /* Hack for backward compatibility: convert options of type
     optionSet to configOf.  FIXME: remove eventually. */
  fixupOptionType = loc: opt:
    let
      options' = opt.options or
        (throw "Option `${showOption loc'}' has type optionSet but has no option attribute.");
      coerce = x:
        if builtins.isFunction x then x
        else { config, ... }: { options = x; };
      options = map coerce (flatten options');
      f = tp:
        if tp.name == "option set" then types.submodule options
        else if tp.name == "attribute set of option sets" then types.attrsOf (types.submodule options)
        else if tp.name == "list or attribute set of option sets" then types.loaOf (types.submodule options)
        else if tp.name == "list of option sets" then types.listOf (types.submodule options)
        else if tp.name == "null or option set" then types.nullOr (types.submodule options)
        else tp;
    in opt // { type = f (opt.type or types.unspecified); };


  /* Properties. */

  mkIf = condition: content:
    { _type = "if";
      inherit condition content;
    };

  mkAssert = assertion: message: content:
    mkIf
      (if assertion then true else throw "\nFailed assertion: ${message}")
      content;

  mkMerge = contents:
    { _type = "merge";
      inherit contents;
    };

  mkOverride = priority: content:
    { _type = "override";
      inherit priority content;
    };

  mkOptionDefault = mkOverride 1001;
  mkDefault = mkOverride 1000;
  mkForce = mkOverride 50;

  mkFixStrictness = id; # obsolete, no-op

  # FIXME: Add mkOrder back in. It's not currently used anywhere in
  # NixOS, but it should be useful.

}
