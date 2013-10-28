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
          unifyModuleSyntax "<unknown-file>" "anon-${toString n}" (applyIfFunction x args)
        else
          unifyModuleSyntax (toString x) (toString x) (applyIfFunction (import x) args);
      toClosureList = imap (path: coerceToModule path);
    in
      builtins.genericClosure {
        startSet = toClosureList modules;
        operator = m: toClosureList m.imports;
      };

  /* Massage a module into canonical form, that is, a set consisting
     of ‘options’, ‘config’ and ‘imports’ attributes. */
  unifyModuleSyntax = file: key: m:
    if m ? config || m ? options || m ? imports then
      let badAttrs = removeAttrs m ["imports" "options" "config"]; in
      if badAttrs != {} then
        throw "Module `${key}' has an unsupported attribute `${head (attrNames badAttrs)}'. ${builtins.toXML m} "
      else
        { inherit file key;
          imports = m.imports or [];
          options = m.options or {};
          config = m.config or {};
        }
    else
      { inherit file key;
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
    mergeModules' [] modules
      (concatMap (m: map (config: { inherit (m) file; inherit config; }) (pushDownProperties m.config)) modules);

  mergeModules' = loc: options: configs:
    let names = concatMap (m: attrNames m.options) options;
    in listToAttrs (map (name: {
      # We're descending into attribute ‘name’.
      inherit name;
      value =
        let
          loc' = loc ++ [name];
          # Get all submodules that declare ‘name’.
          decls = concatLists (map (m:
            optional (hasAttr name m.options)
              { inherit (m) file; options = getAttr name m.options; }
            ) options);
          # Get all submodules that define ‘name’.
          defns = concatLists (map (m:
            optionals (hasAttr name m.config)
              (map (config: { inherit (m) file; inherit config; })
                (pushDownProperties (getAttr name m.config)))
            ) configs);
          nrOptions = count (m: isOption m.options) decls;

          defns2 = concatMap (m:
            optional (hasAttr name m.config)
              { inherit (m) file; config = getAttr name m.config; }
            ) configs;
        in
          if nrOptions == length decls then
            let opt = fixupOptionType loc' (mergeOptionDecls loc' decls);
            in evalOptionValue loc' opt defns2
          else if nrOptions != 0 then
            let
              firstOption = findFirst (m: isOption m.options) "" decls;
              firstNonOption = findFirst (m: !isOption m.options) "" decls;
            in
              throw "The option `${showOption loc'}' in `${firstOption.file}' is a prefix of options in `${firstNonOption.file}'."
          else
            mergeModules' loc' decls defns;
    }) names);

  /* Merge multiple option declarations into a single declaration.  In
     general, there should be only one declaration of each option.
     The exception is the ‘options’ attribute, which specifies
     sub-options.  These can be specified multiple times to allow one
     module to add sub-options to an option declared somewhere else
     (e.g. multiple modules define sub-options for ‘fileSystems’). */
  mergeOptionDecls = loc: opts:
    fold (opt: res:
      if opt.options ? default && res ? default ||
         opt.options ? example && res ? example ||
         opt.options ? description && res ? description ||
         opt.options ? merge && res ? merge ||
         opt.options ? apply && res ? apply ||
         opt.options ? type && res ? type
      then
        throw "The option `${showOption loc}' in `${opt.file}' is already declared in ${concatStringsSep " and " (map (d: "`${d}'") res.declarations)}."
      else
        opt.options // res //
          { declarations = [opt.file] ++ res.declarations;
            options = optionals (opt.options ? options) (toList opt.options.options ++ res.options);
          }
    ) { declarations = []; options = []; } opts;

  /* Merge all the definitions of an option to produce the final
     config value. */
  evalOptionValue = loc: opt: cfgs:
    let
      # Process mkMerge and mkIf properties.
      defs' = concatMap (m: map (config: { inherit (m) file; inherit config; }) (dischargeProperties m.config)) cfgs;
      # Process mkOverride properties, adding in the default
      # value specified in the option declaration (if any).
      defsFinal = filterOverrides (optional (opt ? default) ({ file = head opt.declarations; config = mkOptionDefault opt.default; }) ++ defs');
      # Type-check the remaining definitions, and merge them if
      # possible.
      merged =
        if defsFinal == [] then
          throw "The option `${showOption loc}' is used but not defined."
        else
          fold (def: res:
            if opt.type.check def.config then res
            else throw "The option value `${showOption loc}' in `${def.file}' is not a ${opt.type.name}.")
            (opt.type.merge (map (m: m.config) defsFinal)) defsFinal;
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

       [ { file = "/1"; config = mkOverride 10 "a"; }
         { file = "/2"; config = mkOverride 20 "b"; }
         { file = "/3"; config = "z"; }
         { file = "/4"; config = mkOverride 10 "d"; }
       ]

     yields

       [ { file = "/1"; config = "a"; }
         { file = "/4"; config = "d"; }
       ]

     Note that "z" has the default priority 100.
  */
  filterOverrides = defs:
    let
      defaultPrio = 100;
      getPrio = def: if def.config._type or "" == "override" then def.config.priority else defaultPrio;
      min = x: y: if x < y then x else y;
      highestPrio = fold (def: prio: min (getPrio def) prio) 9999 defs;
      strip = def: if def.config._type or "" == "override" then def // { config = def.config.content; } else def;
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
