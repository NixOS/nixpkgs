with import ./lists.nix;
with import ./trivial.nix;
with import ./attrsets.nix;
with import ./options.nix;
with import ./debug.nix;
with import ./types.nix;

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
                  # there's _module.args.
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
            type = types.attrsOf types.unspecified;
            internal = true;
            description = "Arguments passed to each module.";
          };

          _module.check = mkOption {
            type = types.bool;
            internal = true;
            default = check;
            description = "Whether to check whether all option definitions have matching declarations.";
          };
        };

        config = {
          _module.args = args;
        };
      };

      closed = closeModules (modules ++ [ internalModule ]) ({ inherit config options; lib = import ./.; } // specialArgs);

      # Note: the list of modules is reversed to maintain backward
      # compatibility with the old module system.  Not sure if this is
      # the most sensible policy.
      options = mergeModules prefix (reverseList closed);

      # Traverse options and extract the option values into the final
      # config set.  At the same time, check whether all option
      # definitions have matching declarations.
      # !!! _module.check's value can't depend on any other config values
      # without an infinite recursion. One way around this is to make the
      # 'config' passed around to the modules be unconditionally unchecked,
      # and only do the check in 'result'.
      config = yieldConfig prefix options;
      yieldConfig = prefix: set:
        let res = removeAttrs (mapAttrs (n: v:
          if isOption v then v.value
          else yieldConfig (prefix ++ [n]) v) set) ["_definedNames"];
        in
        if options._module.check.value && set ? _definedNames then
          foldl' (res: m:
            foldl' (res: name:
              if set ? ${name} then res else throw "The option `${showOption (prefix ++ [name])}' defined in `${m.file}' does not exist.")
              res m.names)
            res set._definedNames
        else
          res;
      result = { inherit options config; };
    in result;

  /* Close a set of modules under the ‘imports’ relation. */
  closeModules = modules: args:
    let
      toClosureList = file: parentKey: imap (n: x:
        if isAttrs x || isFunction x then
          let key = "${parentKey}:anon-${toString n}"; in
          unifyModuleSyntax file key (unpackSubmodule (applyIfFunction key) x args)
        else
          let file = toString x; key = toString x; in
          unifyModuleSyntax file key (applyIfFunction key (import x) args));
    in
      builtins.genericClosure {
        startSet = toClosureList unknownModule "" modules;
        operator = m: toClosureList m.file m.key m.imports;
      };

  /* Massage a module into canonical form, that is, a set consisting
     of ‘options’, ‘config’ and ‘imports’ attributes. */
  unifyModuleSyntax = file: key: m:
    let metaSet = if m ? meta 
      then { meta = m.meta; }
      else {};
    in
    if m ? config || m ? options then
      let badAttrs = removeAttrs m ["imports" "options" "config" "key" "_file" "meta"]; in
      if badAttrs != {} then
        throw "Module `${key}' has an unsupported attribute `${head (attrNames badAttrs)}'. This is caused by assignments to the top-level attributes `config' or `options'."
      else
        { file = m._file or file;
          key = toString m.key or key;
          imports = m.imports or [];
          options = m.options or {};
          config = mkMerge [ (m.config or {}) metaSet ];
        }
    else
      { file = m._file or file;
        key = toString m.key or key;
        imports = m.require or [] ++ m.imports or [];
        options = {};
        config = mkMerge [ (removeAttrs m ["key" "_file" "require" "imports"]) metaSet ];
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
      requiredArgs = builtins.attrNames (builtins.functionArgs f);
      context = name: ''while evaluating the module argument `${name}' in "${key}":'';
      extraArgs = builtins.listToAttrs (map (name: {
        inherit name;
        value = addErrorContext (context name)
          (args.${name} or config._module.args.${name});
      }) requiredArgs);

      # Note: we append in the opposite order such that we can add an error
      # context on the explicited arguments of "args" too. This update
      # operator is used to make the "args@{ ... }: with args.lib;" notation
      # works.
    in f (args // extraArgs)
  else
    f;

  /* We have to pack and unpack submodules. We cannot wrap the expected
     result of the function as we would no longer be able to list the arguments
     of the submodule. (see applyIfFunction) */
  unpackSubmodule = unpack: m: args:
    if isType "submodule" m then
      { _file = m.file; } // (unpack m.submodule args)
    else unpack m args;

  packSubmodule = file: m:
    { _type = "submodule"; file = file; submodule = m; };

  /* Merge a list of modules.  This will recurse over the option
     declarations in all modules, combining them into a single set.
     At the same time, for each option declaration, it will merge the
     corresponding option definitions in all machines, returning them
     in the ‘value’ attribute of each option. */
  mergeModules = prefix: modules:
    mergeModules' prefix modules
      (concatMap (m: map (config: { inherit (m) file; inherit config; }) (pushDownProperties m.config)) modules);

  mergeModules' = prefix: options: configs:
    listToAttrs (map (name: {
      # We're descending into attribute ‘name’.
      inherit name;
      value =
        let
          loc = prefix ++ [name];
          # Get all submodules that declare ‘name’.
          decls = concatMap (m:
            if m.options ? ${name}
              then [ { inherit (m) file; options = m.options.${name}; } ]
              else []
            ) options;
          # Get all submodules that define ‘name’.
          defns = concatMap (m:
            if m.config ? ${name}
              then map (config: { inherit (m) file; inherit config; })
                (pushDownProperties m.config.${name})
              else []
            ) configs;
          nrOptions = count (m: isOption m.options) decls;
          # Extract the definitions for this loc
          defns' = map (m: { inherit (m) file; value = m.config.${name}; })
            (filter (m: m.config ? ${name}) configs);
        in
          if nrOptions == length decls then
            let opt = fixupOptionType loc (mergeOptionDecls loc decls);
            in evalOptionValue loc opt defns'
          else if nrOptions != 0 then
            let
              firstOption = findFirst (m: isOption m.options) "" decls;
              firstNonOption = findFirst (m: !isOption m.options) "" decls;
            in
              throw "The option `${showOption loc}' in `${firstOption.file}' is a prefix of options in `${firstNonOption.file}'."
          else
            mergeModules' loc decls defns;
    }) (concatMap (m: attrNames m.options) options))
    // { _definedNames = map (m: { inherit (m) file; names = attrNames m.config; }) configs; };

  /* Merge multiple option declarations into a single declaration.  In
     general, there should be only one declaration of each option.
     The exception is the ‘options’ attribute, which specifies
     sub-options.  These can be specified multiple times to allow one
     module to add sub-options to an option declared somewhere else
     (e.g. multiple modules define sub-options for ‘fileSystems’).

     'loc' is the list of attribute names where the option is located.

     'opts' is a list of modules.  Each module has an options attribute which
     correspond to the definition of 'loc' in 'opt.file'. */
  mergeOptionDecls = loc: opts:
    foldl' (res: opt:
      if opt.options ? default && res ? default ||
         opt.options ? example && res ? example ||
         opt.options ? description && res ? description ||
         opt.options ? apply && res ? apply ||
         # Accept to merge options which have identical types.
         opt.options ? type && res ? type && opt.options.type.name != res.type.name
      then
        throw "The option `${showOption loc}' in `${opt.file}' is already declared in ${showFiles res.declarations}."
      else
        let
          /* Add the modules of the current option to the list of modules
             already collected.  The options attribute except either a list of
             submodules or a submodule. For each submodule, we add the file of the
             current option declaration as the file use for the submodule.  If the
             submodule defines any filename, then we ignore the enclosing option file. */
          options' = toList opt.options.options;
          coerceOption = file: opt:
            if isFunction opt then packSubmodule file opt
            else packSubmodule file { options = opt; };
          getSubModules = opt.options.type.getSubModules or null;
          submodules =
            if getSubModules != null then map (packSubmodule opt.file) getSubModules ++ res.options
            else if opt.options ? options then map (coerceOption opt.file) options' ++ res.options
            else res.options;
        in opt.options // res //
          { declarations = res.declarations ++ [opt.file];
            options = submodules;
          }
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
          throw "The option `${showOption loc}' is read-only, but it's set multiple times."
        else
          mergeDefinitions loc opt.type defs';

      # Check whether the option is defined, and apply the ‘apply’
      # function to the merged value.  This allows options to yield a
      # value computed from the definitions.
      value =
        if !res.isDefined then
          throw "The option `${showOption loc}' is used but not defined."
        else if opt ? apply then
          opt.apply res.mergedValue
        else
          res.mergedValue;

    in opt //
      { value = addErrorContext "while evaluating the option `${showOption loc}':" value;
        definitions = map (def: def.value) res.defsFinal;
        files = map (def: def.file) res.defsFinal;
        inherit (res) isDefined;
      };

  # Merge definitions of a value of a given type.
  mergeDefinitions = loc: type: defs: rec {
    defsFinal =
      let
        # Process mkMerge and mkIf properties.
        defs' = concatMap (m:
          map (value: { inherit (m) file; inherit value; }) (dischargeProperties m.value)
        ) defs;

        # Process mkOverride properties.
        defs'' = filterOverrides defs';

        # Sort mkOrder properties.
        defs''' =
          # Avoid sorting if we don't have to.
          if any (def: def.value._type or "" == "order") defs''
          then sortProperties defs''
          else defs'';
      in defs''';

    # Type-check the remaining definitions, and merge them.
    mergedValue = foldl' (res: def:
      if type.check def.value then res
      else throw "The option value `${showOption loc}' in `${def.file}' is not a ${type.name}.")
      (type.merge loc defsFinal) defsFinal;

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
      if def.condition then
        dischargeProperties def.content
      else
        [ ]
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
  filterOverrides = defs:
    let
      defaultPrio = 100;
      getPrio = def: if def.value._type or "" == "override" then def.value.priority else defaultPrio;
      highestPrio = foldl' (prio: def: min (getPrio def) prio) 9999 defs;
      strip = def: if def.value._type or "" == "override" then def // { value = def.value.content; } else def;
    in concatMap (def: if getPrio def == highestPrio then [(strip def)] else []) defs;

  /* Sort a list of properties.  The sort priority of a property is
     1000 by default, but can be overriden by wrapping the property
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
        (throw "Option `${showOption loc'}' has type optionSet but has no option attribute, in ${showFiles opt.declarations}.");
      f = tp:
        if tp.name == "option set" || tp.name == "submodule" then
          throw "The option ${showOption loc} uses submodules without a wrapping type, in ${showFiles opt.declarations}."
        else if tp.name == "attribute set of option sets" then types.attrsOf (types.submodule options)
        else if tp.name == "list or attribute set of option sets" then types.loaOf (types.submodule options)
        else if tp.name == "list of option sets" then types.listOf (types.submodule options)
        else if tp.name == "null or option set" then types.nullOr (types.submodule options)
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

  mkOptionDefault = mkOverride 1001; # priority of option defaults
  mkDefault = mkOverride 1000; # used in config sections of non-user modules to set a default
  mkForce = mkOverride 50;
  mkVMOverride = mkOverride 10; # used by ‘nixos-rebuild build-vm’

  mkStrict = builtins.trace "`mkStrict' is obsolete; use `mkOverride 0' instead." (mkOverride 0);

  mkFixStrictness = id; # obsolete, no-op

  mkOrder = priority: content:
    { _type = "order";
      inherit priority content;
    };

  mkBefore = mkOrder 500;
  mkAfter = mkOrder 1500;


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
    mkMerge
      (optional (isOption option && option.isDefined)
        (wrap (mkMerge option.definitions)));


  /* Compatibility. */
  fixMergeModules = modules: args: evalModules { inherit modules args; check = false; };


  /* Return a module that causes a warning to be shown if the
     specified option is defined. For example,

       mkRemovedOptionModule [ "boot" "loader" "grub" "bootDevice" ] "<replacement instructions>"

     causes a warning if the user defines boot.loader.grub.bootDevice.

     replacementInstructions is a string that provides instructions on
     how to achieve the same functionality without the removed option,
     or alternatively a reasoning why the functionality is not needed.
     replacementInstructions SHOULD be provided!
  */
  mkRemovedOptionModule = optionName: replacementInstructions:
    { options, ... }:
    { options = setAttrByPath optionName (mkOption {
        visible = false;
      });
      config.warnings =
        let opt = getAttrFromPath optionName options; in
        optional opt.isDefined ''
            The option definition `${showOption optionName}' in ${showFiles opt.files} no longer has any effect; please remove it.
            ${replacementInstructions}'';
    };

  /* Return a module that causes a warning to be shown if the
     specified "from" option is defined; the defined value is however
     forwarded to the "to" option. This can be used to rename options
     while providing backward compatibility. For example,

       mkRenamedOptionModule [ "boot" "copyKernels" ] [ "boot" "loader" "grub" "copyKernels" ]

     forwards any definitions of boot.copyKernels to
     boot.loader.grub.copyKernels while printing a warning.
  */
  mkRenamedOptionModule = from: to: doRename {
    inherit from to;
    visible = false;
    warn = true;
    use = builtins.trace "Obsolete option `${showOption from}' is used. It was renamed to `${showOption to}'.";
  };

  /* Like ‘mkRenamedOptionModule’, but doesn't show a warning. */
  mkAliasOptionModule = from: to: doRename {
    inherit from to;
    visible = true;
    warn = false;
    use = id;
  };

  doRename = { from, to, visible, warn, use }:
    let
      toOf = attrByPath to
        (abort "Renaming error: option `${showOption to}' does not exists.");
    in
      { config, options, ... }:
      { options = setAttrByPath from (mkOption {
          description = "Alias of <option>${showOption to}</option>.";
          apply = x: use (toOf config);
        });
        config = {
          warnings =
            let opt = getAttrFromPath from options; in
            optional (warn && opt.isDefined)
              "The option `${showOption from}' defined in ${showFiles opt.files} has been renamed to `${showOption to}'.";
        } // setAttrByPath to (mkAliasDefinitions (getAttrFromPath from options));
      };

}
