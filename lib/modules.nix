{ lib }:

let
  inherit (lib)
    addErrorContext
    all
    any
    attrByPath
    attrNames
    catAttrs
    concatLists
    concatMap
    concatStringsSep
    elem
    filter
    foldl'
    functionArgs
    getAttrFromPath
    genericClosure
    head
    id
    imap1
    isAttrs
    isBool
    isFunction
    isInOldestRelease
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
    seq
    setAttrByPath
    substring
    throwIfNot
    trace
    typeOf
    types
    unsafeGetAttrPos
    warn
    warnIf
    zipAttrs
    zipAttrsWith
    ;
  inherit (lib.options)
    isOption
    mkOption
    showDefs
    showFiles
    showOption
    unknownModule
    ;
  inherit (lib.strings)
    isConvertibleWithToString
    ;

  showDeclPrefix = loc: decl: prefix:
    " - option(s) with prefix `${showOption (loc ++ [prefix])}' in module `${decl._file}'";
  showRawDecls = loc: decls:
    concatStringsSep "\n"
      (sort (a: b: a < b)
        (concatMap
          (decl: map
            (showDeclPrefix loc decl)
            (attrNames decl.options)
          )
          decls
      ));

  /* See https://nixos.org/manual/nixpkgs/unstable/#module-system-lib-evalModules
     or file://./../doc/module-system/module-system.chapter.md

     !!! Please think twice before adding to this argument list! The more
     that is specified here instead of in the modules themselves the harder
     it is to transparently move a set of modules to be a submodule of another
     config (as the proper arguments need to be replicated at each call to
     evalModules) and the less declarative the module set is. */
  evalModules = evalModulesArgs@
                { modules
                , prefix ? []
                , # This should only be used for special arguments that need to be evaluated
                  # when resolving module structure (like in imports). For everything else,
                  # there's _module.args. If specialArgs.modulesPath is defined it will be
                  # used as the base path for disabledModules.
                  specialArgs ? {}
                , # `class`:
                  # A nominal type for modules. When set and non-null, this adds a check to
                  # make sure that only compatible modules are imported.
                  class ? null
                , # This would be remove in the future, Prefer _module.args option instead.
                  args ? {}
                , # This would be remove in the future, Prefer _module.check option instead.
                  check ? true
                }:
    let
      withWarnings = x:
        warnIf (evalModulesArgs?args) "The args argument to evalModules is deprecated. Please set config._module.args instead."
        warnIf (evalModulesArgs?check) "The check argument to evalModules is deprecated. Please set config._module.check instead."
        x;

      legacyModules =
        optional (evalModulesArgs?args) {
          config = {
            _module.args = args;
          };
        }
        ++ optional (evalModulesArgs?check) {
          config = {
            _module.check = mkDefault check;
          };
        };
      regularModules = modules ++ legacyModules;

      # This internal module declare internal options under the `_module'
      # attribute.  These options are fragile, as they are used by the
      # module system to change the interpretation of modules.
      #
      # When extended with extendModules or moduleType, a fresh instance of
      # this module is used, to avoid conflicts and allow chaining of
      # extendModules.
      internalModule = rec {
        _file = "lib/modules.nix";

        key = _file;

        options = {
          _module.args = mkOption {
            # Because things like `mkIf` are entirely useless for
            # `_module.args` (because there's no way modules can check which
            # arguments were passed), we'll use `lazyAttrsOf` which drops
            # support for that, in turn it's lazy in its values. This means e.g.
            # a `_module.args.pkgs = import (fetchTarball { ... }) {}` won't
            # start a download when `pkgs` wasn't evaluated.
            type = types.lazyAttrsOf types.raw;
            # Only render documentation once at the root of the option tree,
            # not for all individual submodules.
            # Allow merging option decls to make this internal regardless.
            ${if prefix == []
              then null  # unset => visible
              else "internal"} = true;
            # TODO: Change the type of this option to a submodule with a
            # freeformType, so that individual arguments can be documented
            # separately
            description = ''
              Additional arguments passed to each module in addition to ones
              like `lib`, `config`,
              and `pkgs`, `modulesPath`.

              This option is also available to all submodules. Submodules do not
              inherit args from their parent module, nor do they provide args to
              their parent module or sibling submodules. The sole exception to
              this is the argument `name` which is provided by
              parent modules to a submodule and contains the attribute name
              the submodule is bound to, or a unique generated name if it is
              not bound to an attribute.

              Some arguments are already passed by default, of which the
              following *cannot* be changed with this option:
              - {var}`lib`: The nixpkgs library.
              - {var}`config`: The results of all options after merging the values from all modules together.
              - {var}`options`: The options declared in all modules.
              - {var}`specialArgs`: The `specialArgs` argument passed to `evalModules`.
              - All attributes of {var}`specialArgs`

                Whereas option values can generally depend on other option values
                thanks to laziness, this does not apply to `imports`, which
                must be computed statically before anything else.

                For this reason, callers of the module system can provide `specialArgs`
                which are available during import resolution.

                For NixOS, `specialArgs` includes
                {var}`modulesPath`, which allows you to import
                extra modules from the nixpkgs package tree without having to
                somehow make the module aware of the location of the
                `nixpkgs` or NixOS directories.
                ```
                { modulesPath, ... }: {
                  imports = [
                    (modulesPath + "/profiles/minimal.nix")
                  ];
                }
                ```

              For NixOS, the default value for this option includes at least this argument:
              - {var}`pkgs`: The nixpkgs package set according to
                the {option}`nixpkgs.pkgs` option.
            '';
          };

          _module.check = mkOption {
            type = types.bool;
            internal = true;
            default = true;
            description = "Whether to check whether all option definitions have matching declarations.";
          };

          _module.freeformType = mkOption {
            type = types.nullOr types.optionType;
            internal = true;
            default = null;
            description = ''
              If set, merge all definitions that don't have an associated option
              together using this type. The result then gets combined with the
              values of all declared options to produce the final `
              config` value.

              If this is `null`, definitions without an option
              will throw an error unless {option}`_module.check` is
              turned off.
            '';
          };

          _module.specialArgs = mkOption {
            readOnly = true;
            internal = true;
            description = ''
              Externally provided module arguments that can't be modified from
              within a configuration, but can be used in module imports.
            '';
          };
        };

        config = {
          _module.args = {
            inherit extendModules;
            moduleType = type;
          };
          _module.specialArgs = specialArgs;
        };
      };

      merged =
        let collected = collectModules
          class
          (specialArgs.modulesPath or "")
          (regularModules ++ [ internalModule ])
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
            baseMsg =
              let
                optText = showOption (prefix ++ firstDef.prefix);
                defText =
                  addErrorContext
                    "while evaluating the error message for definitions for `${optText}', which is an option that does not exist"
                    (addErrorContext
                      "while evaluating a definition from `${firstDef.file}'"
                      ( showDefs [ firstDef ])
                    );
              in
                "The option `${optText}' does not exist. Definition values:${defText}";
          in
            if attrNames options == [ "_module" ]
              # No options were declared at all (`_module` is built in)
              # but we do have unmatched definitions, and no freeformType (earlier conditions)
              then
                let
                  optionName = showOption prefix;
                in
                  if optionName == ""
                    then throw ''
                      ${baseMsg}

                      It seems as if you're trying to declare an option by placing it into `config' rather than `options'!
                    ''
                  else
                    throw ''
                      ${baseMsg}

                      However there are no options defined in `${showOption prefix}'. Are you sure you've
                      declared your options properly? This can happen if you e.g. declared your options in `types.submodule'
                      under `config' rather than `options'.
                    ''
            else throw baseMsg
        else null;

      checked = seq checkUnmatched;

      extendModules = extendArgs@{
        modules ? [],
        specialArgs ? {},
        prefix ? [],
        }:
          evalModules (evalModulesArgs // {
            inherit class;
            modules = regularModules ++ modules;
            specialArgs = evalModulesArgs.specialArgs or {} // specialArgs;
            prefix = extendArgs.prefix or evalModulesArgs.prefix or [];
          });

      type = types.submoduleWith {
        inherit modules specialArgs class;
      };

      result = withWarnings {
        _type = "configuration";
        options = checked options;
        config = checked (removeAttrs config [ "_module" ]);
        _module = checked (config._module);
        inherit extendModules type;
        class = class;
      };
    in result;

  # collectModules :: (class: String) -> (modulesPath: String) -> (modules: [ Module ]) -> (args: Attrs) -> [ Module ]
  #
  # Collects all modules recursively through `import` statements, filtering out
  # all modules in disabledModules.
  collectModules = class: let

      # Like unifyModuleSyntax, but also imports paths and calls functions if necessary
      loadModule = args: fallbackFile: fallbackKey: m:
        if isFunction m then
          unifyModuleSyntax fallbackFile fallbackKey (applyModuleArgs fallbackKey m args)
        else if isAttrs m then
          if m._type or "module" == "module" then
            unifyModuleSyntax fallbackFile fallbackKey m
          else if m._type == "if" || m._type == "override" then
            loadModule args fallbackFile fallbackKey { config = m; }
          else
            throw (messages.not_a_module { inherit fallbackFile; value = m; _type = m._type; expectedClass = class; })
        else if isList m then
          let defs = [{ file = fallbackFile; value = m; }]; in
          throw "Module imports can't be nested lists. Perhaps you meant to remove one level of lists? Definitions: ${showDefs defs}"
        else unifyModuleSyntax (toString m) (toString m) (applyModuleArgsIfFunction (toString m) (import m) args);

      checkModule =
        if class != null
        then
          m:
            if m._class != null -> m._class == class
            then m
            else
              throw "The module ${m._file or m.key} was imported into ${class} instead of ${m._class}."
        else
          m: m;

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
            module = checkModule (loadModule args parentFile "${parentKey}:anon-${toString n}" x);
            collectedImports = collectStructuredModules module._file module.key module.imports args;
          in {
            key = module.key;
            module = module;
            modules = collectedImports.modules;
            disabled = (if module.disabledModules != [] then [{ file = module._file; disabled = module.disabledModules; }] else []) ++ collectedImports.disabled;
          }) initialModules);

      # filterModules :: String -> { disabled, modules } -> [ Module ]
      #
      # Filters a structure as emitted by collectStructuredModules by removing all disabled
      # modules recursively. It returns the final list of unique-by-key modules
      filterModules = modulesPath: { disabled, modules }:
        let
          moduleKey = file: m:
            if isString m
            then
              if substring 0 1 m == "/"
              then m
              else toString modulesPath + "/" + m

            else if isConvertibleWithToString m
            then
              if m?key && m.key != toString m
              then
                throw "Module `${file}` contains a disabledModules item that is an attribute set that can be converted to a string (${toString m}) but also has a `.key` attribute (${m.key}) with a different value. This makes it ambiguous which module should be disabled."
              else
                toString m

            else if m?key
            then
              m.key

            else if isAttrs m
            then throw "Module `${file}` contains a disabledModules item that is an attribute set, presumably a module, that does not have a `key` attribute. This means that the module system doesn't have any means to identify the module that should be disabled. Make sure that you've put the correct value in disabledModules: a string path relative to modulesPath, a path value, or an attribute set with a `key` attribute."
            else throw "Each disabledModules item must be a path, string, or a attribute set with a key attribute, or a value supported by toString. However, one of the disabledModules items in `${toString file}` is none of that, but is of type ${typeOf m}.";

          disabledKeys = concatMap ({ file, disabled }: map (moduleKey file) disabled) disabled;
          keyFilter = filter (attrs: ! elem attrs.key disabledKeys);
        in map (attrs: attrs.module) (genericClosure {
          startSet = keyFilter modules;
          operator = attrs: keyFilter attrs.modules;
        });

    in modulesPath: initialModules: args:
      filterModules modulesPath (collectStructuredModules unknownModule "" initialModules args);

  /* Wrap a module with a default location for reporting errors. */
  setDefaultModuleLocation = file: m:
    { _file = file; imports = [ m ]; };

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
      let badAttrs = removeAttrs m ["_class" "_file" "key" "disabledModules" "imports" "options" "config" "meta" "freeformType"]; in
      if badAttrs != {} then
        throw "Module `${key}' has an unsupported attribute `${head (attrNames badAttrs)}'. This is caused by introducing a top-level `config' or `options' attribute. Add configuration attributes immediately on the top level instead, or move all of them (namely: ${toString (attrNames badAttrs)}) into the explicit `config' attribute."
      else
        { _file = toString m._file or file;
          _class = m._class or null;
          key = toString m.key or key;
          disabledModules = m.disabledModules or [];
          imports = m.imports or [];
          options = m.options or {};
          config = addFreeformType (addMeta (m.config or {}));
        }
    else
      # shorthand syntax
      throwIfNot (isAttrs m) "module ${file} (${key}) does not look like a module."
      { _file = toString m._file or file;
        _class = m._class or null;
        key = toString m.key or key;
        disabledModules = m.disabledModules or [];
        imports = m.require or [] ++ m.imports or [];
        options = {};
        config = addFreeformType (removeAttrs m ["_class" "_file" "key" "disabledModules" "require" "imports" "freeformType"]);
      };

  applyModuleArgsIfFunction = key: f: args@{ config, ... }:
    if isFunction f then applyModuleArgs key f args else f;

  applyModuleArgs = key: f: args@{ config, ... }:
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
      extraArgs = mapAttrs (name: _:
        addErrorContext (context name)
          (args.${name} or config._module.args.${name})
      ) (functionArgs f);

      # Note: we append in the opposite order such that we can add an error
      # context on the explicit arguments of "args" too. This update
      # operator is used to make the "args@{ ... }: with args.lib;" notation
      # works.
    in f (args // extraArgs);

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

  mergeModules' = prefix: modules: configs:
    let
      # an attrset 'name' => list of submodules that declare ‘name’.
      declsByName =
        zipAttrsWith
          (n: concatLists)
          (map
            (module: let subtree = module.options; in
              if !(isAttrs subtree) then
                throw ''
                  An option declaration for `${concatStringsSep "." prefix}' has type
                  `${typeOf subtree}' rather than an attribute set.
                  Did you mean to define this outside of `options'?
                ''
              else
                mapAttrs
                  (n: option:
                    [{ inherit (module) _file; pos = unsafeGetAttrPos n subtree; options = option; }]
                  )
                  subtree
              )
            modules);

      # The root of any module definition must be an attrset.
      checkedConfigs =
        assert
          all
            (c:
              # TODO: I have my doubts that this error would occur when option definitions are not matched.
              #       The implementation of this check used to be tied to a superficially similar check for
              #       options, so maybe that's why this is here.
              isAttrs c.config || throw ''
                In module `${c.file}', you're trying to define a value of type `${typeOf c.config}'
                rather than an attribute set for the option
                `${concatStringsSep "." prefix}'!

                This usually happens if `${concatStringsSep "." prefix}' has option
                definitions inside that are not matched. Please check how to properly define
                this option by e.g. referring to `man 5 configuration.nix'!
              ''
            )
            configs;
        configs;

      # an attrset 'name' => list of submodules that define ‘name’.
      pushedDownDefinitionsByName =
        zipAttrsWith
          (n: concatLists)
          (map
            (module:
              mapAttrs
                (n: value:
                  map (config: { inherit (module) file; inherit config; }) (pushDownProperties value)
                )
              module.config
            )
            checkedConfigs);
      # extract the definitions for each loc
      rawDefinitionsByName =
        zipAttrsWith
          (n: concatLists)
          (map
            (module:
              mapAttrs
                (n: value:
                  [{ inherit (module) file; inherit value; }]
                )
                module.config
            )
            checkedConfigs);

      # Convert an option tree decl to a submodule option decl
      optionTreeToOption = decl:
        if isOption decl.options
        then decl
        else decl // {
            options = mkOption {
              type = types.submoduleWith {
                modules = [ { options = decl.options; } ];
                # `null` is not intended for use by modules. It is an internal
                # value that means "whatever the user has declared elsewhere".
                # This might become obsolete with https://github.com/NixOS/nixpkgs/issues/162398
                shorthandOnlyDefinesConfig = null;
              };
            };
          };

      resultsByName = mapAttrs (name: decls:
        # We're descending into attribute ‘name’.
        let
          loc = prefix ++ [name];
          defns = pushedDownDefinitionsByName.${name} or [];
          defns' = rawDefinitionsByName.${name} or [];
          optionDecls = filter
            (m: m.options?_type
                && (m.options._type == "option"
                    || throwDeclarationTypeError loc m.options._type m._file
                )
            )
            decls;
        in
          if length optionDecls == length decls then
            let opt = fixupOptionType loc (mergeOptionDecls loc decls);
            in {
              matchedOptions = evalOptionValue loc opt defns';
              unmatchedDefns = [];
            }
          else if optionDecls != [] then
              if all (x: x.options.type.name or null == "submodule") optionDecls
              # Raw options can only be merged into submodules. Merging into
              # attrsets might be nice, but ambiguous. Suppose we have
              # attrset as a `attrsOf submodule`. User declares option
              # attrset.foo.bar, this could mean:
              #  a. option `bar` is only available in `attrset.foo`
              #  b. option `foo.bar` is available in all `attrset.*`
              #  c. reject and require "<name>" as a reminder that it behaves like (b).
              #  d. magically combine (a) and (c).
              # All of the above are merely syntax sugar though.
              then
                let opt = fixupOptionType loc (mergeOptionDecls loc (map optionTreeToOption decls));
                in {
                  matchedOptions = evalOptionValue loc opt defns';
                  unmatchedDefns = [];
                }
              else
                let
                  nonOptions = filter (m: !isOption m.options) decls;
                in
                throw "The option `${showOption loc}' in module `${(head optionDecls)._file}' would be a parent of the following options, but its type `${(head optionDecls).options.type.description or "<no description>"}' does not support nested options.\n${
                  showRawDecls loc nonOptions
                }"
          else
            mergeModules' loc decls defns) declsByName;

      matchedOptions = mapAttrs (n: v: v.matchedOptions) resultsByName;

      # an attrset 'name' => list of unmatched definitions for 'name'
      unmatchedDefnsByName =
        # Propagate all unmatched definitions from nested option sets
        mapAttrs (n: v: v.unmatchedDefns) resultsByName
        # Plus the definitions for the current prefix that don't have a matching option
        // removeAttrs rawDefinitionsByName (attrNames matchedOptions);
    in {
      inherit matchedOptions;

      # Transforms unmatchedDefnsByName into a list of definitions
      unmatchedDefns =
        if configs == []
        then
          # When no config values exist, there can be no unmatched config, so
          # we short circuit and avoid evaluating more _options_ than necessary.
          []
        else
          concatLists (mapAttrsToList (name: defs:
            map (def: def // {
              # Set this so we know when the definition first left unmatched territory
              prefix = [name] ++ (def.prefix or []);
            }) defs
          ) unmatchedDefnsByName);
    };

  throwDeclarationTypeError = loc: actualTag: file:
    let
      name = lib.strings.escapeNixIdentifier (lib.lists.last loc);
      path = showOption loc;
      depth = length loc;

      paragraphs = [
        "In module ${file}: expected an option declaration at option path `${path}` but got an attribute set with type ${actualTag}"
      ] ++ optional (actualTag == "option-type") ''
          When declaring an option, you must wrap the type in a `mkOption` call. It should look somewhat like:
              ${comment}
              ${name} = lib.mkOption {
                description = ...;
                type = <the type you wrote for ${name}>;
                ...
              };
        '';

      # Ideally we'd know the exact syntax they used, but short of that,
      # we can only reliably repeat the last. However, we repeat the
      # full path in a non-misleading way here, in case they overlook
      # the start of the message. Examples attract attention.
      comment = optionalString (depth > 1) "\n    # ${showOption loc}";
    in
    throw (concatStringsSep "\n\n" paragraphs);

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
   loc: opts:
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
          getSubModules = opt.options.type.getSubModules or null;
          submodules =
            if getSubModules != null then map (setDefaultModuleLocation opt._file) getSubModules ++ res.options
            else res.options;
        in opt.options // res //
          { declarations = res.declarations ++ [opt._file];
            # In the case of modules that are generated dynamically, we won't
            # have exact declaration lines; fall back to just the file being
            # evaluated.
            declarationPositions = res.declarationPositions
              ++ (if opt.pos != null
                then [opt.pos]
                else [{ file = opt._file; line = null; column = null; }]);
            options = submodules;
          } // typeSet
    ) { inherit loc; declarations = []; declarationPositions = []; options = []; } opts;

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
      { value = addErrorContext "while evaluating the option `${showOption loc}':" value;
        inherit (res.defsFinal') highestPrio;
        definitions = map (def: def.value) res.defsFinal;
        files = map (def: def.file) res.defsFinal;
        definitionsWithLocations = res.defsFinal;
        inherit (res) isDefined;
        # This allows options to be correctly displayed using `${options.path.to.it}`
        __toString = _: showOption loc;
      };

  # Merge definitions of a value of a given type.
  mergeDefinitions = loc: type: defs: rec {
    defsFinal' =
      let
        # Process mkMerge and mkIf properties.
        defs' = concatMap (m:
          map (value: { inherit (m) file; inherit value; }) (addErrorContext "while evaluating definitions from `${m.file}':" (dischargeProperties m.value))
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
        throw "The option `${showOption loc}' was accessed but has no value defined. Try setting the option.";

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
      getPrio = def: if def.value._type or "" == "override" then def.value.priority else defaultOverridePriority;
      highestPrio = foldl' (prio: def: min (getPrio def) prio) 9999 defs;
      strip = def: if def.value._type or "" == "override" then def // { value = def.value.content; } else def;
    in {
      values = concatMap (def: if getPrio def == highestPrio then [(strip def)] else []) defs;
      inherit highestPrio;
    };

  /* Sort a list of properties.  The sort priority of a property is
     defaultOrderPriority by default, but can be overridden by wrapping the property
     using mkOrder. */
  sortProperties = defs:
    let
      strip = def:
        if def.value._type or "" == "order"
        then def // { value = def.value.content; inherit (def.value) priority; }
        else def;
      defs' = map strip defs;
      compare = a: b: (a.priority or defaultOrderPriority) < (b.priority or defaultOrderPriority);
    in sort compare defs';

  # This calls substSubModules, whose entire purpose is only to ensure that
  # option declarations in submodules have accurate position information.
  # TODO: Merge this into mergeOptionDecls
  fixupOptionType = loc: opt:
    if opt.type.getSubModules or null == null
    then opt // { type = opt.type or types.unspecified; }
    else opt // { type = opt.type.substSubModules opt.options; options = []; };


  /*
    Merge an option's definitions in a way that preserves the priority of the
    individual attributes in the option value.

    This does not account for all option semantics, such as readOnly.

    Type:
      option -> attrsOf { highestPrio, value }
  */
  mergeAttrDefinitionsWithPrio = opt:
        let
            defsByAttr =
              zipAttrs (
                concatLists (
                  concatMap
                    ({ value, ... }@def:
                      map
                        (mapAttrsToList (k: value: { ${k} = def // { inherit value; }; }))
                        (pushDownProperties value)
                    )
                    opt.definitionsWithLocations
                )
              );
        in
          assert opt.type.name == "attrsOf" || opt.type.name == "lazyAttrsOf";
          mapAttrs
                (k: v:
                  let merging = mergeDefinitions (opt.loc ++ [k]) opt.type.nestedTypes.elemType v;
                  in {
                    value = merging.mergedValue;
                    inherit (merging.defsFinal') highestPrio;
                  })
                defsByAttr;

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
  defaultOverridePriority = 100;
  mkImageMediaOverride = mkOverride 60; # image media profiles can be derived by inclusion into host config, hence needing to override host config, but do allow user to mkForce
  mkForce = mkOverride 50;
  mkVMOverride = mkOverride 10; # used by ‘nixos-rebuild build-vm’

  defaultPriority = warnIf (isInOldestRelease 2305) "lib.modules.defaultPriority is deprecated, please use lib.modules.defaultOverridePriority instead." defaultOverridePriority;

  mkFixStrictness = warn "lib.mkFixStrictness has no effect and will be removed. It returns its argument unmodified, so you can just remove any calls." id;

  mkOrder = priority: content:
    { _type = "order";
      inherit priority content;
    };

  mkBefore = mkOrder 500;
  defaultOrderPriority = 1000;
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
    mkAliasIfDef option (wrap (mkMerge option.definitions));

  # Similar to mkAliasAndWrapDefinitions but copies over the priority from the
  # option as well.
  #
  # If a priority is not set, it assumes a priority of defaultOverridePriority.
  mkAliasAndWrapDefsWithPriority = wrap: option:
    let
      prio = option.highestPrio or defaultOverridePriority;
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
    use = trace "Obsolete option `${showOption from}' is used. It was renamed to `${showOption to}'.";
  };

  mkRenamedOptionModuleWith = {
    /* Old option path as list of strings. */
    from,
    /* New option path as list of strings. */
    to,

    /*
      Release number of the first release that contains the rename, ignoring backports.
      Set it to the upcoming release, matching the nixpkgs/.version file.
    */
    sinceRelease,

  }: doRename {
    inherit from to;
    visible = false;
    warn = isInOldestRelease sinceRelease;
    use = warnIf (isInOldestRelease sinceRelease)
      "Obsolete option `${showOption from}' is used. It was renamed to `${showOption to}'.";
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
      options = foldl' recursiveUpdate {} (map (path: setAttrByPath path (mkOption {
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

  /* Transitional version of mkAliasOptionModule that uses MD docs.

     This function is no longer necessary and merely an alias of `mkAliasOptionModule`.
  */
  mkAliasOptionModuleMD = mkAliasOptionModule;

  /* mkDerivedConfig : Option a -> (a -> Definition b) -> Definition b

    Create config definitions with the same priority as the definition of another option.
    This should be used for option definitions where one option sets the value of another as a convenience.
    For instance a config file could be set with a `text` or `source` option, where text translates to a `source`
    value using `mkDerivedConfig options.text (pkgs.writeText "filename.conf")`.

    It takes care of setting the right priority using `mkOverride`.
  */
  # TODO: make the module system error message include information about `opt` in
  # error messages about conflicts. E.g. introduce a variation of `mkOverride` which
  # adds extra location context to the definition object. This will allow context to be added
  # to all messages that report option locations "this value was derived from <full option name>
  # which was defined in <locations>". It can provide a trace of options that contributed
  # to definitions.
  mkDerivedConfig = opt: f:
    mkOverride
      (opt.highestPrio or defaultOverridePriority)
      (f opt.value);

  /*
    Return a module that help declares an option that has been renamed.
    When a value is defined for the old option, it is forwarded to the `to` option.
   */
  doRename = {
    # List of strings representing the attribute path of the old option.
    from,
    # List of strings representing the attribute path of the new option.
    to,
    # Boolean, whether the old option is to be included in documentation.
    visible,
    # Whether to warn when a value is defined for the old option.
    # NOTE: This requires the NixOS assertions module to be imported, so
    #        - this generally does not work in submodules
    #        - this may or may not work outside NixOS
    warn,
    # A function that is applied to the option value, to form the value
    # of the old `from` option.
    #
    # For example, the identity function can be passed, to return the option value unchanged.
    # ```nix
    # use = x: x;
    # ```
    #
    # To add a warning, you can pass the partially applied `warn` function.
    # ```nix
    # use = lib.warn "Obsolete option `${opt.old}' is used. Use `${opt.to}' instead.";
    # ```
    use,
    # Legacy option, enabled by default: whether to preserve the priority of definitions in `old`.
    withPriority ? true,
    # A boolean that defines the `mkIf` condition for `to`.
    # If the condition evaluates to `true`, and the `to` path points into an
    # `attrsOf (submodule ...)`, then `doRename` would cause an empty module to
    # be created, even if the `from` option is undefined.
    # By setting this to an expression that may return `false`, you can inhibit
    # this undesired behavior.
    #
    # Example:
    #
    # ```nix
    # { config, lib, ... }:
    # let
    #   inherit (lib) mkOption mkEnableOption types doRename;
    # in
    # {
    #   options = {
    #
    #     # Old service
    #     services.foo.enable = mkEnableOption "foo";
    #
    #     # New multi-instance service
    #     services.foos = mkOption {
    #       type = types.attrsOf (types.submodule …);
    #     };
    #   };
    #   imports = [
    #     (doRename {
    #       from = [ "services" "foo" "bar" ];
    #       to = [ "services" "foos" "" "bar" ];
    #       visible = true;
    #       warn = false;
    #       use = x: x;
    #       withPriority = true;
    #       # Only define services.foos."" if needed. (It's not just about `bar`)
    #       condition = config.services.foo.enable;
    #     })
    #   ];
    # }
    # ```
    condition ? true
  }:
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
        description = "Alias of {option}`${showOption to}`.";
        apply = x: use (toOf config);
      } // optionalAttrs (toType != null) {
        type = toType;
      });
      config = mkIf condition (mkMerge [
        (optionalAttrs (options ? warnings) {
          warnings = optional (warn && fromOpt.isDefined)
            "The option `${showOption from}' defined in ${showFiles fromOpt.files} has been renamed to `${showOption to}'.";
        })
        (if withPriority
          then mkAliasAndWrapDefsWithPriority (setAttrByPath to) fromOpt
          else mkAliasAndWrapDefinitions (setAttrByPath to) fromOpt)
      ]);
    };

  /**
    `importApply file arg :: Path -> a -> Module`,  where `import file :: a -> Module`

    `importApply` imports a Nix expression file much like the module system would,
    after passing an extra positional argument to the function in the file.

    This function should be used when declaring a module in a file that refers to
    values from a different scope, such as that in a flake.

    It solves the problems of alternative solutions:

    - While `importApply file arg` is _mostly_ equivalent to
      `import file arg`, the latter returns a module without a location,
      as `import` only returns the contained expression. This leads to worse
      error messages.

    - Using `specialArgs` to provide arguments to all modules. This effectively
      creates an incomplete module, and requires the user of the module to
      manually pass the `specialArgs` to the configuration, which is error-prone,
      verbose, and unnecessary.

    The nix file must contain a function that returns a module.
    A module may itself be a function, so the file is often a function with two
    positional arguments instead of one. See the example below.

    This function does not add support for deduplication and `disabledModules`,
    although that could be achieved by wrapping the returned module and setting
    the `_key` module attribute.
    The reason for this omission is that the file path is not guaranteed to be
    a unique identifier for the module, as two instances of the module may
    reference different `arg`s in their closures.

    Example

        # lib.nix
        imports = [
          (lib.modules.importApply ./module.nix { bar = bar; })
        ];

        # module.nix
        { bar }:
        { lib, config, ... }:
        {
          options = ...;
          config = ... bar ...;
        }

  */
  importApply =
    modulePath: staticArg:
      lib.setDefaultModuleLocation modulePath (import modulePath staticArg);

  /* Use this function to import a JSON file as NixOS configuration.

     modules.importJSON :: path -> attrs
  */
  importJSON = file: {
    _file = file;
    config = lib.importJSON file;
  };

  /* Use this function to import a TOML file as NixOS configuration.

     modules.importTOML :: path -> attrs
  */
  importTOML = file: {
    _file = file;
    config = lib.importTOML file;
  };

  private = mapAttrs
    (k: warn "External use of `lib.modules.${k}` is deprecated. If your use case isn't covered by non-deprecated functions, we'd like to know more and perhaps support your use case well, instead of providing access to these low level functions. In this case please open an issue in https://github.com/nixos/nixpkgs/issues/.")
    {
      inherit
        applyModuleArgsIfFunction
        dischargeProperties
        mergeModules
        mergeModules'
        pushDownProperties
        unifyModuleSyntax
        ;
      collectModules = collectModules null;
    };

  /**
    Error messages produced by the module system.

    We factor these out to improve the flow when reading the code.

    Functions in `messages` that produce error messages are spelled in
    lower_snake_case. This goes against the convention in order to make the
    error message implementation more readable, and to visually distinguish
    them from other functions in the module system.
   */
  messages = let
    inherit (lib.strings) concatMapStringsSep escapeNixString trim;
    /** "" or ", in file FOO" */
    into_fallback_file_maybe = file:
      optionalString
        (file != null && file != unknownModule)
        ", while trying to load a module into ${toString file}";

    /** Format text with one line break between each list item. */
    lines = concatMapStringsSep "\n" trim;

    /** Format text with two line break between each list item. */
    paragraphs = concatMapStringsSep "\n\n" trim;

    /**
      ```
      optionalMatch
        { foo = "Foo result";
          bar = "Bar result";
        } "foo"
        ==  [ "Foo result" ]

      optionalMatch { foo = "Foo"; } "baz"  ==  [ ]

      optionalMatch { foo = "Foo"; } true   ==  [ ]
      ```
     */
    optionalMatch = cases: value:
      if isString value && cases?${value}
      then [ cases.${value} ]
      else [];

    # esc = builtins.fromJSON "\"\\u001b\"";
    esc = builtins.fromJSON "\"\\u001b\"";
    # Bold purple for warnings
    warn = s: "${esc}[1;35m${s}${esc}[0m";
    # Bold green for suggestions
    good = s: "${esc}[1;32m${s}${esc}[0m";
    # Bold, default color for code
    code = s: "${esc}[1m${s}${esc}[0m";

  in {

    /** When load a value with a (wrong) _type as a module  */
    not_a_module = { fallbackFile, value, _type, expectedClass ? null }:
      paragraphs (
        [ ''
            Expected a module, but found a value of type ${warn (escapeNixString _type)}${into_fallback_file_maybe fallbackFile}.
            A module is typically loaded by adding it the ${code "imports = [ ... ];"} attribute of an existing module, or in the ${code "modules = [ ... ];"} argument of various functions.
            Please make sure that each of the list items is a module, and not a different kind of value.
          ''
        ]
        ++ (optionalMatch
          {
            "configuration" = trim ''
              If you really mean to import this configuration, instead please only import the modules that make up the configuration.
              You may have to create a `let` binding, file or attribute to give yourself access to the relevant modules.
              While loading a configuration into the module system is a very sensible idea, it can not be done cleanly in practice.
            '';
            # ^^ Extended explanation: That's because a finalized configuration is more than just a set of modules. For instance, it has its own `specialArgs` that, by the nature of `specialArgs` can't be loaded through `imports` or the the `modules` argument. So instead, we have to ask you to extract the relevant modules and use those instead. This way, we keep the module system comparatively simple, and hopefully avoid a bad surprise down the line.

            "flake" = lines
              ([(trim ''
                Perhaps you forgot to select an attribute name?
                Instead of, for example,
                    ${warn "inputs.someflake"}
                you need to write something like
                    ${warn "inputs.someflake"}${
                      if expectedClass == null
                      then good ".modules.someApp.default"
                      else good ".modules.${expectedClass}.default"

                    }
            '')]
            ++ optionalMatch
              { # We'll no more than 5 custom suggestions here.
                # Please switch to `.modules.${class}` in your Module System application.
                "nixos" = trim ''
                  or
                      ${warn "inputs.someflake"}${good ".nixosModules.default"}
                '';
                "darwin" = trim ''
                  or
                      ${warn "inputs.someflake"}${good ".darwinModules.default"}
                '';
              }
              expectedClass
            );
          }
          _type
        )
      );
  };

in
private //
{
  # NOTE: not all of these functions are necessarily public interfaces; some
  #       are just needed by types.nix, but are not meant to be consumed
  #       externally.
  inherit
    defaultOrderPriority
    defaultOverridePriority
    defaultPriority
    doRename
    evalModules
    evalOptionValue  # for use by lib.types
    filterOverrides
    filterOverrides'
    fixMergeModules
    fixupOptionType  # should be private?
    importApply
    importJSON
    importTOML
    mergeDefinitions
    mergeAttrDefinitionsWithPrio
    mergeOptionDecls  # should be private?
    mkAfter
    mkAliasAndWrapDefinitions
    mkAliasAndWrapDefsWithPriority
    mkAliasDefinitions
    mkAliasIfDef
    mkAliasOptionModule
    mkAliasOptionModuleMD
    mkAssert
    mkBefore
    mkChangedOptionModule
    mkDefault
    mkDerivedConfig
    mkFixStrictness
    mkForce
    mkIf
    mkImageMediaOverride
    mkMerge
    mkMergedOptionModule
    mkOptionDefault
    mkOrder
    mkOverride
    mkRemovedOptionModule
    mkRenamedOptionModule
    mkRenamedOptionModuleWith
    mkVMOverride
    setDefaultModuleLocation
    sortProperties;
}
