{ config, lib, options, extendModules, moduleType, ... }:
let
  inherit (lib) mkOption optionalAttrs types mdDoc;

  extendModule = module: extendModules { modules = [ module ]; };

  extend = module: config.callTest ((extendModule module).config.result);

  decisionModule = decision@{ name, ... }: {
    options = {
      choice = mkOption {
        type = types.lazyAttrsOf (types.submodule (choiceModule decision.name extendModules));
        description = ''
          An attribute set where each attribute name corresponds to a choice; a single outcome of a decision.

          When you define `matrix.foo.choice.bar`, it creates a copy of the test configuration inside `matrix.foo.choice.bar.module`, where the module argument `foo` will be set to `bar`.

          `runTest` will traverse all matrix choices, so that in all the final test configurations it returns, a choice for `foo` has been made.
        '';
      };
      after = mkOption {
        description = mdDoc ''
          This option affects the order in which `runTest` decides which
          decisions to make first.

          Instead of reading for example
          `matrix.bar.choice.qux.module.matrix.foo.choice.xyz`,
          you can define

          ```
            matrix.bar.after = ["foo"];
          ```

          so that `runTest` will read
          `matrix.foo.choice.xyz.module.matrix.bar.choice.qux` instead.

          This would usually amount to the same thing, unless you want the set
          of `choice` attributes to be affected by the value of `foo`, which
          isn't possible in the default ordering.

          You'd typically use this with [`matrix.<name>.enable`](#test-opt-matrix._name_.enable)
          to make sure that definitions from "earlier" decisions are taken into account.
        '';
        type = types.listOf types.str;
        default = [ ];
      };
      enable = mkOption {
        type = types.bool;
        default = true;
        description = mdDoc ''
          Allows a decision to be disabled. When set to `false`, none of the
          choices will be applied, and the depth of the relevant subtree
          returned by `runTest` will be reduced by one node.

          A similar effect can be achieved with
          {option}`matrix.<name>.choice.<name>.enable`, which allows single
          choices to be omitted, but does not reduce the decision tree depth.

          By avoiding useless test parameter combinations, you can reduce your testing workload,
          and by avoiding nonsensical combinations, you can make all reasonable tests pass.

          Make sure that `runTest` doesn't inspect this
          decision too soon, thereby ensuring that all required definitions
          are available. A typical use may look as follows:

          ```nix
          # For this example, we suppose that our application has a backend
          # selection option, which only allowed when dynamic linking is enabled.

          { linking, ... }:
          {
            matrix.backend = {
              after = ["linking"];
              enable = linking != "static";

              # Neither choice module will be applied when static linking is enabled.
              # If static linking does need some extra settings, set them in
              # `matrix.linking.choice.static.module` instead.
              choice.rest.module = ...;
              choice.smtp.module = ...;
            };
          }
          ```
        '';
      };
    };
  };

  choiceModule = decisionName: extendModules: { name, ... }: {
    options = {
      enable = mkOption {
        description = mdDoc ''
          Whether to produce a test for this choice.

          This can be used in combination with {option}`matrix.<name>.after` to
          make sure all information is present. For example:

          ```nix
          { backend, ... }: {
            matrix.backend.choice.rest = ...;
            matrix.backend.choice.smtp = ...;

            # Make sure testsuite logic only runs where backend
            # has been decided.
            matrix.testsuite.after = ["backend"];

            matrix.testsuite.choice.transactions = {

              # The SMTP backend does not support transactions.
              enable = backend != "smtp";

              module = ...;
            };
            matrix.testsuite.choice.login = ...;
          }
          ```
        '';
        type = types.bool;
        default = true;
      };
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
        The `matrix` options let you define parameterized tests, test scenarios
        with conditional configuration, test cases that run separately in isolated builds, and arbitrary combinations of those.

        The commonality between these features is multiplicity, or equivalently from another perspective: choice.

        This option constructs a hierarchy of options, where each decision to be made is represented by `<...>.matrix.<name>`.
        These options themselves contain `choice.<name>`, which represent the possible values for each decision.

        The `module` submodule is special, because it duplicates and extends the entire test configuration that existed before making the decision.
        When you define option values in it, those will only apply when `runTest` reads that specific choice.

        For a more hands-on introduction, see [Constructing a test matrix](#sec-nixos-test-matrix).

        While it is possible to achieve the bare essence of the `matrix` options by applying functions such as `genAttrs` and `mapAttrs`,
        the difference is that the `matrix` options make the intent and the structure of such code explicit and uniform.
        The benefits include a general solution for the [disabling of version matrixes](https://nixos.org/manual/nixpkgs/unstable/#ssec-nixos-tests-linking), as required for package "passthru" tests.
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
        nextDecision = (lib.head sortedEnable).name;
      in
      if sortedEnable == [ ]
      then config
      else
        lib.recurseIntoAttrs
          (
            lib.mapAttrs'
              (k: v: lib.nameValuePair "${nextDecision}-${k}" v.module.result)
              (lib.filterAttrs
                (k: v: v.enable)
                config.matrix.${nextDecision}.choice
              )
          )
        // config.exposeIntermediateAttrs config;
  };
}
