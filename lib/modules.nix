{ lib }:

let
  inherit (lib)
    all
    any
    attrByPath
    attrNames
    catAttrs
    concatLists
    concatMap
    count
    elem
    filter
    findFirst
    flip
    foldl
    foldl'
    getAttrFromPath
    head
    id
    imap1
    isAttrs
    isBool
    isFunction
    isList
    isString
    length
    mapAttrs
    mapAttrsToList
    mapAttrsRecursiveCond
    min
    optional
    optionalAttrs
    optionalString
    recursiveUpdate
    reverseList sort
    setAttrByPath
    toList
    types
    warnIf
    ;
  inherit (lib.options)
    isOption
    mkOption
    showDefs
    showFiles
    showOption
    unknownModule
    ;
in

rec {

  /* Evaluate a set of modules.  The result is a set of two
     attributes: ‘options’: the nested set of all option declarations,
     and ‘config’: the nested set of all option values.
     !!! Please think twice before adding to this argument list! The more
     that is specified here instead of in the modules themselves the harder
     it is to transparently move a set of modules to be a submodule of another
     config (as the proper arguments need to be replicated at each call to
     evalModules) and the less declarative the module set is. */
  evalModules = { modules
                , prefix ? []
                , # This should only be used for special arguments that need to be evaluated
                  # when resolving module structure (like in imports). For everything else,
                  # there's _module.args. If specialArgs.modulesPath is defined it will be
                  # used as the base path for disabledModules.
                  specialArgs ? {}
                , # This would be remove in the future, Prefer _module.args option instead.
                  args ? {}
                , # This would be remove in the future, Prefer _module.check option instead.
                  check ? true
                }:
    let
      # This internal module declare internal options under the `_module'
      # attribute.  These options are fragile, as they are used by the
      # module system to change the interpretation of modules.
      internalModule = rec {
        _file = ./modules.nix;

        key = _file;

        options = {
          _module.args = mkOption {
            # Because things like `mkIf` are entirely useless for
            # `_module.args` (because there's no way modules can check which
            # arguments were passed), we'll use `lazyAttrsOf` which drops
            # support for that, in turn it's lazy in its values. This means e.g.
            # a `_module.args.pkgs = import (fetchTarball { ... }) {}` won't
            # start a download when `pkgs` wasn't evaluated.
            type = types.lazyAttrsOf types.unspecified;
            internal = true;
            description = "Arguments passed to each module.";
          };

          _module.check = mkOption {
            type = types.bool;
            internal = true;
            default = check;
            description = "Whether to check whether all option definitions have matching declarations.";
          };

          _module.freeformType = mkOption {
            # Disallow merging for now, but could be implemented nicely with a `types.optionType`
            type = types.nullOr (types.uniq types.attrs);
            internal = true;
            default = null;
            description = ''
              If set, merge all definitions that don't have an associated option
              together using this type. The result then gets combined with the
              values of all declared options to produce the final <literal>
              config</literal> value.

              If this is <literal>null</literal>, definitions without an option
              will throw an error unless <option>_module.check</option> is
              turned off.
            '';
          };
        };

        config = {
          _module.args = args;
        };
      };

      merged =
        let collected = collectModules
          (specialArgs.modulesPath or "")
          (modules ++ [ internalModule ])
          ({ inherit lib options config specialArgs; } // specialArgs);
        in mergeModules prefix (reverseList collected);

      options = merged.matchedOptions;

      config =
        let

          # For definitions that have an associated option
          declaredConfig = mapAttrsRecursiveCond (v: ! isOption v) (_: v: v.value) options;

          # If freeformType is set, this is for definitions that don't have an associated option
          freeformConfig =
            let
              defs = map (def: {
                file = def.file;
                value = setAttrByPath def.prefix def.value;
              }) merged.unmatchedDefns;
            in if defs == [] then {}
            else declaredConfig._module.freeformType.merge prefix defs;

        in if declaredConfig._module.freeformType == null then declaredConfig
          # Because all definitions that had an associated option ended in
          # declaredConfig, freeformConfig can only contain the non-option
          # paths, meaning recursiveUpdate will never override any value
          else recursiveUpdate freeformConfig declaredConfig;

      checkUnmatched =
        if config._module.check && config._module.freeformType == null && merged.unmatchedDefns != [] then
          let
            firstDef = head merged.unmatchedDefns;
            baseMsg = "The option `${showOption (prefix ++ firstDef.prefix)}' does not exist. Definition values:${showDefs [ firstDef ]}";
          in
            if attrNames options == [ "_module" ]
              then throw ''
                ${baseMsg}

                However there are no options defined in `${showOption prefix}'. Are you sure you've
                declared your options properly? This can happen if you e.g. declared your options in `types.submodule'
                under `config' rather than `options'.
              ''
            else throw baseMsg
        else null;

      result = builtins.seq checkUnmatched {
        inherit options;
        config = removeAttrs config [ "_module" ];
        inherit (config) _module;
      };
    in result;

  # collectModules :: (modulesPath: String) -> (modules: [ Module ]) -> (args: Attrs) -> [ Module ]
  #
  # Collects all modules recursively through `import` statements, filtering out
  # all modules in disabledModules.
  collectModules = let

      # Like unifyModuleSyntax, but also imports paths and calls functions if necessary
      loadModule = args: fallbackFile: fallbackKey: m:
        if isFunction m || isAttrs m then
          unifyModuleSyntax fallbackFile fallbackKey (applyIfFunction fallbackKey m args)
        else if isList m then
          let defs = [{ file = fallbackFile; value = m; }]; in
          throw "Module imports can't be nested lists. Perhaps you meant to remove one level of lists? Definitions: ${showDefs defs}"
        else unifyModuleSyntax (toString m) (toString m) (applyIfFunction (toString m) (import m) args);

      /*
      Collects all modules recursively into the form

        {
          disabled = [ <list of disabled modules> ];
          # All modules of the main module list
          modules = [
            {
              key = <key1>;
              module = <module for key1>;
              # All modules imported by the module for key1
              modules = [
                {
                  key = <key1-1>;
                  module = <module for key1-1>;
                  # All modules imported by the module for key1-1
                  modules = [ ... ];
                }
                ...
              ];
            }
            ...
          ];
        }
      */
      collectStructuredModules =
        let
          collectResults = modules: {
            disabled = concatLists (catAttrs "disabled" modules);
            inherit modules;
          };
        in parentFile: parentKey: initialModules: args: collectResults (imap1 (n: x:
          let
            module = loadModule args parentFile "${parentKey}:anon-${toString n}" x;
            collectedImports = collectStructuredModules module._file module.key module.imports args;
          in {
            key = module.key;
            module = module;
            modules = collectedImports.modules;
            disabled = module.disabledModules ++ collectedImports.disabled;
          }) initialModules);

      # filterModules :: String -> { disabled, modules } -> [ Module ]
      #
      # Filters a structure as emitted by collectStructuredModules by removing all disabled
      # modules recursively. It returns the final list of unique-by-key modules
      filterModules = modulesPath: { disabled, modules }:
        let
          moduleKey = m: if isString m then toString modulesPath + "/" + m else toString m;
          disabledKeys = map moduleKey disabled;
          keyFilter = filter (attrs: ! elem attrs.key disabledKeys);
        in map (attrs: attrs.module) (builtins.genericClosure {
          startSet = keyFilter modules;
          operator = attrs: keyFilter attrs.modules;
        });

    in modulesPath: initialModules: args:
      filterModules modulesPath (collectStructuredModules unknownModule "" initialModules args);

  /* Massage a module into canonical form, that is, a set consisting
     of ‘options’, ‘config’ and ‘imports’ attributes. */
  unifyModuleSyntax = file: key: m:
    let
      addMeta = config: if m ? meta
        then mkMerge [ config { meta = m.meta; } ]
        else config;
      addFreeformType = config: if m ? freeformType
        then mkMerge [ config { _module.freeformType = m.freeformType; } ]
        else config;
    in
    if m ? config || m ? options then
      let badAttrs = removeAttrs m ["_file" "key" "disabledModules" "imports" "options" "config" "meta" "freeformType"]; in
      if badAttrs != {} then
        throw "Module `${key}' has an unsupported attribute `${head (attrNames badAttrs)}'. This is caused by introducing a top-level `config' or `options' attribute. Add configuration attributes immediately on the top level instead, or move all of them (namely: ${toString (attrNames badAttrs)}) into the explicit `config' attribute."
      else
        { _file = toString m._file or file;
          key = toString m.key or key;
          disabledModules = m.disabledModules or [];
          imports = m.imports or [];
          options = m.options or {};
          config = addFreeformType (addMeta (m.config or {}));
        }
    else
      { _file = toString m._file or file;
        key = toString m.key or key;
        disabledModules = m.disabledModules or [];
        imports = m.require or [] ++ m.imports or [];
        options = {};
        config = addFreeformType (addMeta (removeAttrs m ["_file" "key" "disabledModules" "require" "imports" "freeformType"]));
      };

  applyIfFunction = key: f: args@{ config, options, lib, ... }: if isFunction f then
    let
      # Module arguments are resolved in a strict manner when attribute set
      # deconstruction is used.  As the arguments are now defined with the
      # config._module.args option, the strictness used on the attribute
      # set argument would cause an infinite loop, if the result of the
      # option is given as argument.
      #
      # To work-around the strictness issue on the deconstruction of the
      # attributes set argument, we create a new attribute set which is
      # constructed to satisfy the expected set of attributes.  Thus calling
      # a module will resolve strictly the attributes used as argument but
      # not their values.  The values are forwarding the result of the
      # evaluation of the option.
      context = name: ''while evaluating the module argument `${name}' in "${key}":'';
      extraArgs = builtins.mapAttrs (name: _:
        builtins.addErrorContext (context name)
          (args.${name} or config._module.args.${name})
      ) (lib.functionArgs f);

      # Note: we append in the opposite order such that we can add an error
      # context on the explicited arguments of "args" too. This update
      # operator is used to make the "args@{ ... }: with args.lib;" notation
      # works.
    in f (args // extraArgs)
  else
    f;

  /* Merge a list of modules.  This will recurse over the option
     declarations in all modules, combining them into a single set.
     At the same time, for each option declaration, it will merge the
     corresponding option definitions in all machines, returning them
     in the ‘value’ attribute of each option.

     This returns a set like
       {
         # A recursive set of options along with their final values
         matchedOptions = {
           foo = { _type = "option"; value = "option value of foo"; ... };
           bar.baz = { _type = "option"; value = "option value of bar.baz"; ... };
           ...
         };
         # A list of definitions that weren't matched by any option
         unmatchedDefns = [
           { file = "file.nix"; prefix = [ "qux" ]; value = "qux"; }
           ...
         ];
       }
  */
  mergeModules = prefix: modules:
    mergeModules' prefix modules
      (concatMap (m: map (config: { file = m._file; inherit config; }) (pushDownProperties m.config)) modules);

  mergeModules' = prefix: options: configs:
    let
     /* byName is like foldAttrs, but will look for attributes to merge in the
        specified attribute name.

        byName "foo" (module: value: ["module.hidden=${module.hidden},value=${value}"])
        [
          {
            hidden="baz";
            foo={qux="bar"; gla="flop";};
          }
          {
            hidden="fli";
            foo={qux="gne"; gli="flip";};
          }
        ]
        ===>
        {
          gla = [ "module.hidden=baz,value=flop" ];
          gli = [ "module.hidden=fli,value=flip" ];
          qux = [ "module.hidden=baz,value=bar" "module.hidden=fli,value=gne" ];
        }
      */
      byName = attr: f: modules:
        foldl' (acc: module:
              if !(builtins.isAttrs module.${attr}) then
                throw ''
                  You're trying to declare a value of type `${builtins.typeOf module.${attr}}'
                  rather than an attribute-set for the option
                  `${builtins.concatStringsSep "." prefix}'!

                  This usually happens if `${builtins.concatStringsSep "." prefix}' has option
                  definitions inside that are not matched. Please check how to properly define
                  this option by e.g. referring to `man 5 configuration.nix'!
                ''
              else
                acc // (mapAttrs (n: v:
                                   (acc.${n} or []) ++ f module v
                                 ) module.${attr}
                       )
               ) {} modules;
      # an attrset 'name' => list of submodules that declare ‘name’.
      declsByName = byName "options" (module: option:
          [{ inherit (module) _file; options = option; }]
        ) options;
      # an attrset 'name' => list of submodules that define ‘name’.
      defnsByName = byName "config" (module: value:
          map (config: { inherit (module) file; inherit config; }) (pushDownProperties value)
        ) configs;
      # extract the definitions for each loc
      defnsByName' = byName "config" (module: value:
          [{ inherit (module) file; inherit value; }]
        ) configs;

      resultsByName = flip mapAttrs declsByName (name: decls:
        # We're descending into attribute ‘name’.
        let
          loc = prefix ++ [name];
          defns = defnsByName.${name} or [];
          defns' = defnsByName'.${name} or [];
          nrOptions = count (m: isOption m.options) decls;
        in
          if nrOptions == length decls then
            let opt = fixupOptionType loc (mergeOptionDecls loc decls);
            in {
              matchedOptions = evalOptionValue loc opt defns';
              unmatchedDefns = [];
            }
          else if nrOptions != 0 then
            let
              firstOption = findFirst (m: isOption m.options) "" decls;
              firstNonOption = findFirst (m: !isOption m.options) "" decls;
            in
              throw "The option `${showOption loc}' in `${firstOption._file}' is a prefix of options in `${firstNonOption._file}'."
          else
            mergeModules' loc decls defns);

      matchedOptions = mapAttrs (n: v: v.matchedOptions) resultsByName;

      # an attrset 'name' => list of unmatched definitions for 'name'
      unmatchedDefnsByName =
        # Propagate all unmatched definitions from nested option sets
        mapAttrs (n: v: v.unmatchedDefns) resultsByName
        # Plus the definitions for the current prefix that don't have a matching option
        // removeAttrs defnsByName' (attrNames matchedOptions);
    in {
      inherit matchedOptions;

      # Transforms unmatchedDefnsByName into a list of definitions
      unmatchedDefns = concatLists (mapAttrsToList (name: defs:
        map (def: def // {
          # Set this so we know when the definition first left unmatched territory
          prefix = [name] ++ (def.prefix or []);
        }) defs
      ) unmatchedDefnsByName);
    };

  /* Merge multiple option declarations into a single declaration.  In
     general, there should be only one declaration of each option.
     The exception is the ‘options’ attribute, which specifies
     sub-options.  These can be specified multiple times to allow one
     module to add sub-options to an option declared somewhere else
     (e.g. multiple modules define sub-options for ‘fileSystems’).

     'loc' is the list of attribute names where the option is located.

     'opts' is a list of modules.  Each module has an options attribute which
     correspond to the definition of 'loc' in 'opt.file'. */
  mergeOptionDecls =
   let
    packSubmodule = file: m:
      { _file = file; imports = [ m ]; };
    coerceOption = file: opt:
      if isFunction opt then packSubmodule file opt
      else packSubmodule file { options = opt; };
   in loc: opts:
    foldl' (res: opt:
      let t  = res.type;
          t' = opt.options.type;
          mergedType = t.typeMerge t'.functor;
          typesMergeable = mergedType != null;
          typeSet = if (bothHave "type") && typesMergeable
                       then { type = mergedType; }
                       else {};
          bothHave = k: opt.options ? ${k} && res ? ${k};
      in
      if bothHave "default" ||
         bothHave "example" ||
         bothHave "description" ||
         bothHave "apply" ||
         (bothHave "type" && (! typesMergeable))
      then
        throw "The option `${showOption loc}' in `${opt._file}' is already declared in ${showFiles res.declarations}."
      else
        let
          /* Add the modules of the current option to the list of modules
             already collected.  The options attribute except either a list of
             submodules or a submodule. For each submodule, we add the file of the
             current option declaration as the file use for the submodule.  If the
             submodule defines any filename, then we ignore the enclosing option file. */
          options' = toList opt.options.options;

          getSubModules = opt.options.type.getSubModules or null;
          submodules =
            if getSubModules != null then map (packSubmodule opt._file) getSubModules ++ res.options
            else if opt.options ? options then map (coerceOption opt._file) options' ++ res.options
            else res.options;
        in opt.options // res //
          { declarations = res.declarations ++ [opt._file];
            options = submodules;
          } // typeSet
    ) { inherit loc; declarations = []; options = []; } opts;

  /* Merge all the definitions of an option to produce the final
     config value. */
  evalOptionValue = loc: opt: defs:
    let
      # Add in the default value for this option, if any.
      defs' =
          (optional (opt ? default)
            { file = head opt.declarations; value = mkOptionDefault opt.default; }) ++ defs;

      # Handle properties, check types, and merge everything together.
      res =
        if opt.readOnly or false && length defs' > 1 then
          let
            # For a better error message, evaluate all readOnly definitions as
            # if they were the only definition.
            separateDefs = map (def: def // {
              value = (mergeDefinitions loc opt.type [ def ]).mergedValue;
            }) defs';
          in throw "The option `${showOption loc}' is read-only, but it's set multiple times. Definition values:${showDefs separateDefs}"
        else
          mergeDefinitions loc opt.type defs';

      # Apply the 'apply' function to the merged value. This allows options to
      # yield a value computed from the definitions
      value = if opt ? apply then opt.apply res.mergedValue else res.mergedValue;

      warnDeprecation =
        warnIf (opt.type.deprecationMessage != null)
          "The type `types.${opt.type.name}' of option `${showOption loc}' defined in ${showFiles opt.declarations} is deprecated. ${opt.type.deprecationMessage}";

    in warnDeprecation opt //
      { value = builtins.addErrorContext "while evaluating the option `${showOption loc}':" value;
        inherit (res.defsFinal') highestPrio;
        definitions = map (def: def.value) res.defsFinal;
        files = map (def: def.file) res.defsFinal;
        inherit (res) isDefined;
      };

  # Merge definitions of a value of a given type.
  mergeDefinitions = loc: type: defs: rec {
    defsFinal' =
      let
        # Process mkMerge and mkIf properties.
        defs' = concatMap (m:
          map (value: { inherit (m) file; inherit value; }) (builtins.addErrorContext "while evaluating definitions from `${m.file}':" (dischargeProperties m.value))
        ) defs;

        # Process mkOverride properties.
        defs'' = filterOverrides' defs';

        # Sort mkOrder properties.
        defs''' =
          # Avoid sorting if we don't have to.
          if any (def: def.value._type or "" == "order") defs''.values
          then sortProperties defs''.values
          else defs''.values;
      in {
        values = defs''';
        inherit (defs'') highestPrio;
      };
    defsFinal = defsFinal'.values;

    # Type-check the remaining definitions, and merge them. Or throw if no definitions.
    mergedValue =
      if isDefined then
        if all (def: type.check def.value) defsFinal then type.merge loc defsFinal
        else let allInvalid = filter (def: ! type.check def.value) defsFinal;
        in throw "A definition for option `${showOption loc}' is not of type `${type.description}'. Definition values:${showDefs allInvalid}"
      else
        # (nixos-option detects this specific error message and gives it special
        # handling.  If changed here, please change it there too.)
        throw "The option `${showOption loc}' is used but not defined.";

    isDefined = defsFinal != [];

    optionalValue =
      if isDefined then { value = mergedValue; }
      else {};
  };

  /* Given a config set, expand mkMerge properties, and push down the
     other properties into the children.  The result is a list of
     config sets that do not have properties at top-level.  For
     example,

       mkMerge [ { boot = set1; } (mkIf cond { boot = set2; services = set3; }) ]

     is transformed into

       [ { boot = set1; } { boot = mkIf cond set2; services = mkIf cond set3; } ].

     This transform is the critical step that allows mkIf conditions
     to refer to the full configuration without creating an infinite
     recursion.
  */
  pushDownProperties = cfg:
    if cfg._type or "" == "merge" then
      concatMap pushDownProperties cfg.contents
    else if cfg._type or "" == "if" then
      map (mapAttrs (n: v: mkIf cfg.condition v)) (pushDownProperties cfg.content)
    else if cfg._type or "" == "override" then
      map (mapAttrs (n: v: mkOverride cfg.priority v)) (pushDownProperties cfg.content)
    else # FIXME: handle mkOrder?
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
      if isBool def.condition then
        if def.condition then
          dischargeProperties def.content
        else
          [ ]
      else
        throw "‘mkIf’ called with a non-Boolean condition"
    else
      [ def ];

  /* Given a list of config values, process the mkOverride properties,
     that is, return the values that have the highest (that is,
     numerically lowest) priority, and strip the mkOverride
     properties.  For example,

       [ { file = "/1"; value = mkOverride 10 "a"; }
         { file = "/2"; value = mkOverride 20 "b"; }
         { file = "/3"; value = "z"; }
         { file = "/4"; value = mkOverride 10 "d"; }
       ]

     yields

       [ { file = "/1"; value = "a"; }
         { file = "/4"; value = "d"; }
       ]

     Note that "z" has the default priority 100.
  */
  filterOverrides = defs: (filterOverrides' defs).values;

  filterOverrides' = defs:
    let
      getPrio = def: if def.value._type or "" == "override" then def.value.priority else defaultPriority;
      highestPrio = foldl' (prio: def: min (getPrio def) prio) 9999 defs;
      strip = def: if def.value._type or "" == "override" then def // { value = def.value.content; } else def;
    in {
      values = concatMap (def: if getPrio def == highestPrio then [(strip def)] else []) defs;
      inherit highestPrio;
    };

  /* Sort a list of properties.  The sort priority of a property is
     1000 by default, but can be overridden by wrapping the property
     using mkOrder. */
  sortProperties = defs:
    let
      strip = def:
        if def.value._type or "" == "order"
        then def // { value = def.value.content; inherit (def.value) priority; }
        else def;
      defs' = map strip defs;
      compare = a: b: (a.priority or 1000) < (b.priority or 1000);
    in sort compare defs';

  /* Hack for backward compatibility: convert options of type
     optionSet to options of type submodule.  FIXME: remove
     eventually. */
  fixupOptionType = loc: opt:
    let
      options = opt.options or
        (throw "Option `${showOption loc}' has type optionSet but has no option attribute, in ${showFiles opt.declarations}.");
      f = tp:
        let optionSetIn = type: (tp.name == type) && (tp.functor.wrapped.name == "optionSet");
        in
        if tp.name == "option set" || tp.name == "submodule" then
          throw "The option ${showOption loc} uses submodules without a wrapping type, in ${showFiles opt.declarations}."
        else if optionSetIn "attrsOf" then types.attrsOf (types.submodule options)
        else if optionSetIn "listOf"  then types.listOf  (types.submodule options)
        else if optionSetIn "nullOr"  then types.nullOr  (types.submodule options)
        else tp;
    in
      if opt.type.getSubModules or null == null
      then opt // { type = f (opt.type or types.unspecified); }
      else opt // { type = opt.type.substSubModules opt.options; options = []; };


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

  mkOptionDefault = mkOverride 1500; # priority of option defaults
  mkDefault = mkOverride 1000; # used in config sections of non-user modules to set a default
  mkForce = mkOverride 50;
  mkVMOverride = mkOverride 10; # used by ‘nixos-rebuild build-vm’

  mkOrder = priority: content:
    { _type = "order";
      inherit priority content;
    };

  mkBefore = mkOrder 500;
  mkAfter = mkOrder 1500;

  # The default priority for things that don't have a priority specified.
  defaultPriority = 100;

  # Convenient property used to transfer all definitions and their
  # properties from one option to another. This property is useful for
  # renaming options, and also for including properties from another module
  # system, including sub-modules.
  #
  #   { config, options, ... }:
  #
  #   {
  #     # 'bar' might not always be defined in the current module-set.
  #     config.foo.enable = mkAliasDefinitions (options.bar.enable or {});
  #
  #     # 'barbaz' has to be defined in the current module-set.
  #     config.foobar.paths = mkAliasDefinitions options.barbaz.paths;
  #   }
  #
  # Note, this is different than taking the value of the option and using it
  # as a definition, as the new definition will not keep the mkOverride /
  # mkDefault properties of the previous option.
  #
  mkAliasDefinitions = mkAliasAndWrapDefinitions id;
  mkAliasAndWrapDefinitions = wrap: option:
    mkAliasIfDef option (wrap (mkMerge option.definitions));

  # Similar to mkAliasAndWrapDefinitions but copies over the priority from the
  # option as well.
  #
  # If a priority is not set, it assumes a priority of defaultPriority.
  mkAliasAndWrapDefsWithPriority = wrap: option:
    let
      prio = option.highestPrio or defaultPriority;
      defsWithPrio = map (mkOverride prio) option.definitions;
    in mkAliasIfDef option (wrap (mkMerge defsWithPrio));

  mkAliasIfDef = option:
    mkIf (isOption option && option.isDefined);

  /* Compatibility. */
  fixMergeModules = modules: args: evalModules { inherit modules args; check = false; };


  /* Return a module that causes a warning to be shown if the
     specified option is defined. For example,

       mkRemovedOptionModule [ "boot" "loader" "grub" "bootDevice" ] "<replacement instructions>"

     causes a assertion if the user defines boot.loader.grub.bootDevice.

     replacementInstructions is a string that provides instructions on
     how to achieve the same functionality without the removed option,
     or alternatively a reasoning why the functionality is not needed.
     replacementInstructions SHOULD be provided!
  */
  mkRemovedOptionModule = optionName: replacementInstructions:
    { options, ... }:
    { options = setAttrByPath optionName (mkOption {
        visible = false;
        apply = x: throw "The option `${showOption optionName}' can no longer be used since it's been removed. ${replacementInstructions}";
      });
      config.assertions =
        let opt = getAttrFromPath optionName options; in [{
          assertion = !opt.isDefined;
          message = ''
            The option definition `${showOption optionName}' in ${showFiles opt.files} no longer has any effect; please remove it.
            ${replacementInstructions}
          '';
        }];
    };

  /* Return a module that causes a warning to be shown if the
     specified "from" option is defined; the defined value is however
     forwarded to the "to" option. This can be used to rename options
     while providing backward compatibility. For example,

       mkRenamedOptionModule [ "boot" "copyKernels" ] [ "boot" "loader" "grub" "copyKernels" ]

     forwards any definitions of boot.copyKernels to
     boot.loader.grub.copyKernels while printing a warning.

     This also copies over the priority from the aliased option to the
     non-aliased option.
  */
  mkRenamedOptionModule = from: to: doRename {
    inherit from to;
    visible = false;
    warn = true;
    use = builtins.trace "Obsolete option `${showOption from}' is used. It was renamed to `${showOption to}'.";
  };

  /* Return a module that causes a warning to be shown if any of the "from"
     option is defined; the defined values can be used in the "mergeFn" to set
     the "to" value.
     This function can be used to merge multiple options into one that has a
     different type.

     "mergeFn" takes the module "config" as a parameter and must return a value
     of "to" option type.

       mkMergedOptionModule
         [ [ "a" "b" "c" ]
           [ "d" "e" "f" ] ]
         [ "x" "y" "z" ]
         (config:
           let value = p: getAttrFromPath p config;
           in
           if      (value [ "a" "b" "c" ]) == true then "foo"
           else if (value [ "d" "e" "f" ]) == true then "bar"
           else "baz")

     - options.a.b.c is a removed boolean option
     - options.d.e.f is a removed boolean option
     - options.x.y.z is a new str option that combines a.b.c and d.e.f
       functionality

     This show a warning if any a.b.c or d.e.f is set, and set the value of
     x.y.z to the result of the merge function
  */
  mkMergedOptionModule = from: to: mergeFn:
    { config, options, ... }:
    {
      options = foldl recursiveUpdate {} (map (path: setAttrByPath path (mkOption {
        visible = false;
        # To use the value in mergeFn without triggering errors
        default = "_mkMergedOptionModule";
      })) from);

      config = {
        warnings = filter (x: x != "") (map (f:
          let val = getAttrFromPath f config;
              opt = getAttrFromPath f options;
          in
          optionalString
            (val != "_mkMergedOptionModule")
            "The option `${showOption f}' defined in ${showFiles opt.files} has been changed to `${showOption to}' that has a different type. Please read `${showOption to}' documentation and update your configuration accordingly."
        ) from);
      } // setAttrByPath to (mkMerge
             (optional
               (any (f: (getAttrFromPath f config) != "_mkMergedOptionModule") from)
               (mergeFn config)));
    };

  /* Single "from" version of mkMergedOptionModule.
     Return a module that causes a warning to be shown if the "from" option is
     defined; the defined value can be used in the "mergeFn" to set the "to"
     value.
     This function can be used to change an option into another that has a
     different type.

     "mergeFn" takes the module "config" as a parameter and must return a value of
     "to" option type.

       mkChangedOptionModule [ "a" "b" "c" ] [ "x" "y" "z" ]
         (config:
           let value = getAttrFromPath [ "a" "b" "c" ] config;
           in
           if   value > 100 then "high"
           else "normal")

     - options.a.b.c is a removed int option
     - options.x.y.z is a new str option that supersedes a.b.c

     This show a warning if a.b.c is set, and set the value of x.y.z to the
     result of the change function
  */
  mkChangedOptionModule = from: to: changeFn:
    mkMergedOptionModule [ from ] to changeFn;

  /* Like ‘mkRenamedOptionModule’, but doesn't show a warning. */
  mkAliasOptionModule = from: to: doRename {
    inherit from to;
    visible = true;
    warn = false;
    use = id;
  };

  doRename = { from, to, visible, warn, use, withPriority ? true }:
    { config, options, ... }:
    let
      fromOpt = getAttrFromPath from options;
      toOf = attrByPath to
        (abort "Renaming error: option `${showOption to}' does not exist.");
      toType = let opt = attrByPath to {} options; in opt.type or (types.submodule {});
    in
    {
      options = setAttrByPath from (mkOption {
        inherit visible;
        description = "Alias of <option>${showOption to}</option>.";
        apply = x: use (toOf config);
      } // optionalAttrs (toType != null) {
        type = toType;
      });
      config = mkMerge [
        {
          warnings = optional (warn && fromOpt.isDefined)
            "The option `${showOption from}' defined in ${showFiles fromOpt.files} has been renamed to `${showOption to}'.";
        }
        (if withPriority
          then mkAliasAndWrapDefsWithPriority (setAttrByPath to) fromOpt
          else mkAliasAndWrapDefinitions (setAttrByPath to) fromOpt)
      ];
    };

  /* Use this function to import a JSON file as NixOS configuration.

     importJSON -> path -> attrs
  */
  importJSON = file: {
    _file = file;
    config = lib.importJSON file;
  };

  /* Use this function to import a TOML file as NixOS configuration.

     importTOML -> path -> attrs
  */
  importTOML = file: {
    _file = file;
    config = lib.importTOML file;
  };
}
