{ config, lib, options, extendModules, moduleType, ... }:
let
  inherit (lib) mkOption optionalAttrs types mdDoc;

  extendModule = module: extendModules { modules = [ module ]; };

  extend = module: config.callTest ((extendModule module).config.result);

  decisionModule = decision@{ name, ... }: {
    options = {
      after = mkOption {
        description = mdDoc ''
          > You've already made the choice, now you have to understand it.

          Some choices depend on other choices.

          For example, we wouldn't be able to decide about the cookie before
          we take the pill. Deciding the cookie is not possible without
          crucial values set by the pill. To avoid an error like `The option
          'pill' is used but not defined`, we force the ordering.

          ```nix
            matrix.cookie = {
              after = ["pill"];
            };
          ```
        '';
        type = types.listOf types.str;
        default = [ ];
      };
      enable = mkOption {
        type = types.bool;
        default = true;
        description = mdDoc ''
          > But if you already know, how can I make a choice?

          > Because you didn't come here to make the choice, you've already made it. You're here to try to understand why you made it.

          Some choices don't make sense, because of earlier choices you've made.

          With this option, you can make Nix understand that, pruning nonsensical
          decisions from the returned tree of tests, so that we don't need to
          compute more than necessary.

          ```nix
          matrix.cookie = {
            after = ["pill"];
            enable = config.pill == "red";
            # ...
          ```

          If we chose the blue pill, we would never have to make a choice about
          the cookie, so we skip this choice.
        '';
      };
      choice = mkOption {
        type = types.lazyAttrsOf (types.submodule (choiceModule decision.name extendModules));
        description = ''
          A attribute set where each attribute name corresponds to a choice; a single outcome of the decision.

          When you define `matrix.foo.choice.bar`, the (new) module argument `foo` will be set to `bar` in a reinstantiation of the test configuration that produces the final test.
        '';
      };
    };
  };

  choiceModule = decisionName: extendModules: { name, ... }: {
    options = {
      module = mkOption {
        description = mdDoc ''
          The effects of making a choice. You can specify any test-level option here.

          NixOS-level options can be specified in the {option}`nodes.<name>` and {option}`defaults` sub-options.
        '';
        example = { defaults.services.foo.backend = "xyz"; };
        type = (extendModules { modules = [ (inMatrixModule decisionName name) ]; }).type;
        default = { };
        visible = "shallow";
      };
    };
  };

  inMatrixModule = decisionName: choiceName:
    {
      config = {
        _module.args.${decisionName} = lib.mkDefault choiceName;
        matrixDecisionsMade.${decisionName} = choiceName;
        matrixIsRoot = false;
      };
    };

in
{
  options = {
    matrix = mkOption {
      type = types.lazyAttrsOf (types.submodule decisionModule);
      description = mdDoc ''
        Wake up, Neo...

        Like every other test, it is born into a prison that it cannot smell or taste or touch. A prison for the mind... Unfortunately, no one can be told what the matrix option is. You have to see it for yourself. This is your last chance. After this, there is no turning back.

        You define

        ```nix
          matrix.pill.choice.blue.module = { config, ... }: {
            defaults.networking.domain = "bed.home.lan";
          };
        ```

        and wake up in your bed and believe whatever you want to believe.

        You define

        ```nix
          matrix.pill.choice.red.module = { config, ... }: {
            defaults.networking.domain = "wonderland.example.com";
          };
        ```

        you test in wonderland, and I show you how deep the rabbit hole goes...

        Remember, all I'm offering is the multiverse... Follow me...


      '';
      default = { };
    };
    matrixDecisionsMade = mkOption {
      type = types.attrsOf types.str;
      default = { };
      internal = true;
    };
    result = mkOption {
      description = mdDoc ''
        _Normally computed by the test framework._

        The tests to be run in a single derivation, or nested attrsets
        of derivations when `matrix` options are set.
      '';
      type = types.raw;
    };
    matrixIsRoot = mkOption {
      default = true;
      internal = true;
    };
    extend = mkOption {
      description = mdDoc ''
        A function that allows the test modules to be extended.

        This can be used for overriding a test, and even for undoing a choice
        in a test matrix. For example, in package `tests` (such as `passthru.tests`),
        you want to test exactly that package, and only that package. For example:

        ```nix
        passthru.tests.nixos = nixosTests.foo.extend {
          matrix.version.enable = false;
          _module.args.testPackage = ...;
        };
        ```

        See also [a more complete description in the nixpkgs manual](https://nixos.org/manual/nixpkgs/stable/#ssec-nixos-tests-linking).

        It is a bit like calling `extendModules` but returning a result of `runTest` somehow.
      '';
      readOnly = true;
      default = extend;
      type = types.functionTo types.raw;
    };

    callTest = mkOption {
      description = mdDoc ''
        A function that select the right attribute(s) from the test config,
        for the purpose that the config was created.
      '';
      internal = true;
      example = lib.literalExpression ''
        config: config.test
      '';
      default = config: config.test;
    };
    exposeIntermediateAttrs = mkOption {
      description = mdDoc ''
        A function that adds attributes from `config` to the {option}`result`
        for the intermediate nodes of the test tree - ie the returned attrsets
        representing choices.
      '';
      type = types.functionTo (types.lazyAttrsOf types.raw);
      default = config: {};
      defaultText = lib.literalExpression "config: { }";
      internal = true;
    };
  };
  config = {
    _module.args =
      if config.matrixIsRoot then
        lib.mapAttrs
          (k: _: lib.mkOptionDefault (throw ''
            Test matrix module parameter `${k}` has not been decided yet.
            This can happen when a matrix definition references a matrix-provided
            module parameter before its choice has been decided.

            If you used it in a matrix.<name>.enable field, you may improve the
            ordering of decision with matrix.<name>.after.

            If you used it in a matrix.<name>.choice submodule, you may reference it
            by adding the module parameter to the submodule definition itself.
            For example:

                matrix.foo.choice.bar.module = { config, lib, ${k}, ... }: {
                  xyz = f ${k};
                }

            Alternatively, if `xyz` does not need to be within a `matrix` definition,
            and it is not involved in `matrix` decision making, you can move it up
            into the general module, so that it references the final parameters,
            without taking them from a scope where they haven't been decided yet.
          ''))
          config.matrix
      else { };

    result =
      let
        choicesRemaining = lib.filterAttrs (choice: v: ! config.matrixDecisionsMade?${choice}) config.matrix;
        isBefore = a: b:
          if lib.elem a.name b.value.after
          then true
          else if lib.elem b.name a.value.after
          then false
          else a.name < b.name;
        sorted = lib.toposort isBefore (lib.mapAttrsToList lib.nameValuePair choicesRemaining);
        sortedList =
          if sorted ? cycle then
            throw "The matrix.<choice>.after relation contains a paradox of causality.\n\n> You see, there is only one constant, one universal, it is the only\n> real truth: causality. Action. Reaction. Cause and effect.\n      -- The Merovingian, Matrix Reloaded, Lilly and Lana Wachowski\n\nPlease break the cycle:\n${prettyCycle}"
          else sorted.result;
        prettyCycle =
          lib.concatMapStrings (x: "  ${x.name}     --after-->\n") (sorted.cycle)
          + "  ${(lib.head sorted.cycle).name}";
        sortedEnable = lib.filter (c: c.value.enable) sortedList;
        nextChoice = (lib.head sortedEnable).name;
      in
      if sortedEnable == [ ]
      then config
      else
        lib.recurseIntoAttrs (
          lib.mapAttrs' (k: v: lib.nameValuePair "${nextChoice}-${k}" v.module.result) config.matrix.${nextChoice}.choice
        ) // config.exposeIntermediateAttrs config;
  };
}
