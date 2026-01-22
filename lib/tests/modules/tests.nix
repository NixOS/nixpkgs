{
  lib ? import ../..,
}:
let
  evalTest = import ./default.nix;

  checkConfigOutput =
    {
      expected,
      modules,
      attrPath ? [
        "config"
        "result"
      ],
      apply ? lib.id,
    }:
    let
      t = evalTest {
        inherit lib modules;
      };
    in
    {
      expr = apply (lib.getAttrFromPath attrPath t);
      inherit expected;
    };

  checkConfigError =
    {
      expectedError,
      modules,
      attrPath,
    }:
    let
      t = evalTest {
        inherit lib modules;
      };
    in
    {
      expr = lib.getAttrFromPath attrPath t;
      inherit expectedError;
    };

in
{

  testShorthandMeta = checkConfigOutput {
    expected = "one two";
    modules = [
      ./shorthand-meta.nix
    ];
  };

  testMergeAttrDefinitionsWithPrio = checkConfigOutput {
    expected = true;
    modules = [
      ./test-mergeAttrDefinitionsWithPrio.nix
    ];
  };

  testModuleArgument = checkConfigOutput {
    expected = true;
    modules = [
      ./module-argument-default.nix
    ];
  };

  testGvariant = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "assertion"
    ];
    modules = [
      ./gvariant.nix
    ];
  };

  testSpecialArgsLib = checkConfigOutput {
    expected = "ok";
    modules = [
      ./specialArgs-lib.nix
    ];
  };

  # Checkpoint modules.sh:L144
  testMkOptionInConfig = checkConfigError {
    expectedError.msg = "It seems as if you.re trying to declare an option by placing it into .config. rather than .options.";
    attrPath = [
      "config"
      "wrong1"
    ];
    modules = [
      ./error-mkOption-in-config.nix
    ];
  };

  testMkOptionInConfig2 = checkConfigError {
    expectedError.msg = "It seems as if you.re trying to declare an option by placing it into .config. rather than .options.";
    attrPath = [
      "config"
      "nest"
      "wrong2"
    ];
    modules = [
      ./error-mkOption-in-config.nix
    ];
  };

  testMkOptionInSubmoduleConfig = checkConfigError {
    expectedError.msg = "The option .sub.wrong2. does not exist. Definition values:";
    attrPath = [
      "config"
      "sub"
    ];
    modules = [
      ./error-mkOption-in-submodule-config.nix
    ];
  };
  testMkOptionInSubmoduleConfig2 = checkConfigError {
    expectedError.msg = ".*This can happen if you e.g. declared your options in .types.submodule.";
    attrPath = [
      "config"
      "sub"
    ];
    modules = [
      ./error-mkOption-in-submodule-config.nix
    ];
  };

  testMkOptionInNonEmptyListOfSubmodule = checkConfigError {
    expectedError.msg = ".*A definition for option .bad. is not of type .non-empty .list of .submodule...\.";
    attrPath = [
      "config"
      "bad"
    ];
    modules = [
      ./error-nonEmptyListOf-submodule.nix
    ];
  };

  # Migrate types.attrTag tests
  # checkConfigOutput '^true$' config.okChecks ./types-attrTag.nix
  testTypesAttrTag = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "okChecks"
    ];
    modules = [
      ./types-attrTag.nix
    ];
  };
  # checkConfigError 'A definition for option .intStrings\.syntaxError. is not of type .attribute-tagged union' config.intStrings.syntaxError ./types-attrTag.nix
  testTypesAttrTag2 = checkConfigError {
    expectedError.msg = "A definition for option .intStrings.syntaxError. is not of type .attribute-tagged union";
    attrPath = [
      "config"
      "intStrings"
      "syntaxError"
    ];
    modules = [
      ./types-attrTag.nix
    ];
  };
  # checkConfigError 'A definition for option .intStrings\.syntaxError2. is not of type .attribute-tagged union' config.intStrings.syntaxError2 ./types-attrTag.nix
  testTypesAttrTag3 = checkConfigError {
    expectedError.msg = "A definition for option .intStrings.syntaxError2. is not of type .attribute-tagged union";
    attrPath = [
      "config"
      "intStrings"
      "syntaxError2"
    ];
    modules = [
      ./types-attrTag.nix
    ];
  };
  # checkConfigError 'A definition for option .intStrings\.syntaxError3. is not of type .attribute-tagged union' config.intStrings.syntaxError3 ./types-attrTag.nix
  testTypesAttrTag4 = checkConfigError {
    expectedError.msg = "A definition for option .intStrings.syntaxError3. is not of type .attribute-tagged union";
    attrPath = [
      "config"
      "intStrings"
      "syntaxError3"
    ];
    modules = [
      ./types-attrTag.nix
    ];
  };
  # checkConfigError 'A definition for option .intStrings\.syntaxError4. is not of type .attribute-tagged union' config.intStrings.syntaxError4 ./types-attrTag.nix
  testTypesAttrTag5 = checkConfigError {
    expectedError.msg = "A definition for option .intStrings.syntaxError4. is not of type .attribute-tagged union";
    attrPath = [
      "config"
      "intStrings"
      "syntaxError4"
    ];
    modules = [
      ./types-attrTag.nix
    ];
  };
  # checkConfigError 'A definition for option .intStrings\.mergeError. is not of type .attribute-tagged union' config.intStrings.mergeError ./types-attrTag.nix
  testTypesAttrTag6 = checkConfigError {
    expectedError.msg = "A definition for option .intStrings.mergeError. is not of type .attribute-tagged union";
    attrPath = [
      "config"
      "intStrings"
      "mergeError"
    ];
    modules = [
      ./types-attrTag.nix
    ];
  };
  # checkConfigError 'A definition for option .intStrings\.badTagError. is not of type .attribute-tagged union' config.intStrings.badTagError ./types-attrTag.nix
  testTypesAttrTag7 = checkConfigError {
    expectedError.msg = "A definition for option .intStrings.badTagError. is not of type .attribute-tagged union";
    attrPath = [
      "config"
      "intStrings"
      "badTagError"
    ];
    modules = [
      ./types-attrTag.nix
    ];
  };
  # checkConfigError 'A definition for option .intStrings\.badTagTypeError\.left. is not of type .signed integer.' config.intStrings.badTagTypeError.left ./types-attrTag.nix
  testTypesAttrTag8 = checkConfigError {
    expectedError.msg = "A definition for option .intStrings.badTagTypeError.left. is not of type .signed integer";
    attrPath = [
      "config"
      "intStrings"
      "badTagTypeError"
      "left"
    ];
    modules = [
      ./types-attrTag.nix
    ];
  };
  # checkConfigError 'A definition for option .nested\.right\.left. is not of type .signed integer.' config.nested.right.left ./types-attrTag.nix
  testTypesAttrTag9 = checkConfigError {
    expectedError.msg = "A definition for option .nested.right.left. is not of type .signed integer";
    attrPath = [
      "config"
      "nested"
      "right"
      "left"
    ];
    modules = [
      ./types-attrTag.nix
    ];
  };
  # checkConfigError 'In attrTag, each tag value must be an option, but tag int was a bare type, not wrapped in mkOption.' config.opt.int ./types-attrTag-wrong-decl.nix
  testTypesAttrTag10 = checkConfigError {
    expectedError.msg = "In attrTag, each tag value must be an option, but tag int was a bare type, not wrapped in mkOption";
    attrPath = [
      "config"
      "opt"
      "int"
    ];
    modules = [
      ./types-attrTag-wrong-decl.nix
    ];
  };

  # types.pathInstore
  # checkConfigOutput '".*/store/0lz9p8xhf89kb1c1kk6jxrzskaiygnlh-bash-5.2-p15.drv"' config.pathInStore.ok1 ./types.nix
  testTypesPathInStore = checkConfigOutput {
    expected = "${builtins.storeDir}/0lz9p8xhf89kb1c1kk6jxrzskaiygnlh-bash-5.2-p15.drv";
    attrPath = [
      "config"
      "pathInStore"
      "ok1"
    ];
    modules = [
      ./types.nix
    ];
  };
  # checkConfigOutput '".*/store/0fb3ykw9r5hpayd05sr0cizwadzq1d8q-bash-5.2-p15"' config.pathInStore.ok2 ./types.nix
  testTypesPathInStore2 = checkConfigOutput {
    expected = "${builtins.storeDir}/0fb3ykw9r5hpayd05sr0cizwadzq1d8q-bash-5.2-p15";
    attrPath = [
      "config"
      "pathInStore"
      "ok2"
    ];
    modules = [
      ./types.nix
    ];
  };
  # checkConfigOutput '".*/store/0fb3ykw9r5hpayd05sr0cizwadzq1d8q-bash-5.2-p15/bin/bash"' config.pathInStore.ok3 ./types.nix
  testTypesPathInStore3 = checkConfigOutput {
    expected = "${builtins.storeDir}/0fb3ykw9r5hpayd05sr0cizwadzq1d8q-bash-5.2-p15/bin/bash";
    attrPath = [
      "config"
      "pathInStore"
      "ok3"
    ];
    modules = [
      ./types.nix
    ];
  };
  # checkConfigError 'A definition for option .* is not of type .path in the Nix store.. Definition values:\n\s*- In .*: ""' config.pathInStore.bad1 ./types.nix
  testTypesPathInStore4 = checkConfigError {
    expectedError.msg = "A definition for option .* is not of type .path in the Nix store";
    attrPath = [
      "config"
      "pathInStore"
      "bad1"
    ];
    modules = [
      ./types.nix
    ];
  };
  # checkConfigError 'A definition for option .* is not of type .path in the Nix store.. Definition values:\n\s*- In .*: ".*/store"' config.pathInStore.bad2 ./types.nix
  testTypesPathInStore5 = checkConfigError {
    expectedError.msg = "A definition for option .* is not of type .path in the Nix store";
    attrPath = [
      "config"
      "pathInStore"
      "bad2"
    ];
    modules = [
      ./types.nix
    ];
  };
  # checkConfigError 'A definition for option .* is not of type .path in the Nix store.. Definition values:\n\s*- In .*: ".*/store/"' config.pathInStore.bad3 ./types.nix
  testTypesPathInStore6 = checkConfigError {
    expectedError.msg = "A definition for option .* is not of type .path in the Nix store";
    attrPath = [
      "config"
      "pathInStore"
      "bad3"
    ];
    modules = [
      ./types.nix
    ];
  };
  # checkConfigError 'A definition for option .* is not of type .path in the Nix store.. Definition values:\n\s*- In .*: ".*/store/.links"' config.pathInStore.bad4 ./types.nix
  testTypesPathInStore7 = checkConfigError {
    expectedError.msg = "A definition for option .* is not of type .path in the Nix store";
    attrPath = [
      "config"
      "pathInStore"
      "bad4"
    ];
    modules = [
      ./types.nix
    ];
  };
  # checkConfigError 'A definition for option .* is not of type .path in the Nix store.. Definition values:\n\s*- In .*: "/foo/bar"' config.pathInStore.bad5 ./types.nix
  testTypesPathInStore8 = checkConfigError {
    expectedError.msg = "A definition for option .* is not of type .path in the Nix store";
    attrPath = [
      "config"
      "pathInStore"
      "bad5"
    ];
    modules = [
      ./types.nix
    ];
  };

  # Check boolean option.
  # checkConfigOutput '^false$' config.enable ./declare-enable.nix
  testDeclareEnable = checkConfigOutput {
    expected = false;
    attrPath = [
      "config"
      "enable"
    ];
    modules = [
      ./declare-enable.nix
    ];
  };
  # checkConfigError 'The option .* does not exist. Definition values:\n\s*- In .*: true' config.enable ./define-enable.nix
  testDefineEnable = checkConfigError {
    expectedError.msg = "The option .* does not exist. Definition values:";
    attrPath = [
      "config"
      "enable"
    ];
    modules = [
      ./define-enable.nix
    ];
  };
  # checkConfigError 'The option .* does not exist. Definition values:\n\s*- In .*' config.enable ./define-enable-throw.nix
  testDefineEnableThrow = checkConfigError {
    expectedError.msg = "The option .* does not exist. Definition values:";
    attrPath = [
      "config"
      "enable"
    ];
    modules = [
      ./define-enable-throw.nix
    ];
  };
  # checkConfigError 'while evaluating a definition from `.*/define-enable-abort.nix' config.enable ./define-enable-abort.nix
  testDefineEnableAbort = checkConfigError {
    expectedError.msg = "while evaluating a definition from `.*/define-enable-abort.nix";
    attrPath = [
      "config"
      "enable"
    ];
    modules = [
      ./define-enable-abort.nix
    ];
  };
  # checkConfigError 'while evaluating the error message for definitions for .enable., which is an option that does not exist' config.enable ./define-enable-abort.nix
  testDefineEnableAbort2 = checkConfigError {
    expectedError.msg = "while evaluating the error message for definitions for .enable., which is an option that does not exist";
    attrPath = [
      "config"
      "enable"
    ];
    modules = [
      ./define-enable-abort.nix
    ];
  };

  # Check boolByOr type.
  # checkConfigOutput '^false$' config.value.falseFalse ./boolByOr.nix
  testBoolByOr = checkConfigOutput {
    expected = false;
    attrPath = [
      "config"
      "value"
      "falseFalse"
    ];
    modules = [
      ./boolByOr.nix
    ];
  };
  # checkConfigOutput '^true$' config.value.trueFalse ./boolByOr.nix
  testBoolByOr2 = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "value"
      "trueFalse"
    ];
    modules = [
      ./boolByOr.nix
    ];
  };
  # checkConfigOutput '^true$' config.value.falseTrue ./boolByOr.nix
  testBoolByOr3 = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "value"
      "falseTrue"
    ];
    modules = [
      ./boolByOr.nix
    ];
  };
  # checkConfigOutput '^true$' config.value.trueTrue ./boolByOr.nix
  testBoolByOr4 = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "value"
      "trueTrue"
    ];
    modules = [
      ./boolByOr.nix
    ];
  };

  # Test bare submodule
  # checkConfigOutput '^1$' config.bare-submodule.nested ./declare-bare-submodule.nix ./declare-bare-submodule-nested-option.nix
  testDeclareBareSubmodule = checkConfigOutput {
    expected = 1;
    attrPath = [
      "config"
      "bare-submodule"
      "nested"
    ];
    modules = [
      ./declare-bare-submodule.nix
      ./declare-bare-submodule-nested-option.nix
    ];
  };
  # checkConfigOutput '^2$' config.bare-submodule.deep ./declare-bare-submodule.nix ./declare-bare-submodule-deep-option.nix
  testDeclareBareSubmodule2 = checkConfigOutput {
    expected = 2;
    attrPath = [
      "config"
      "bare-submodule"
      "deep"
    ];
    modules = [
      ./declare-bare-submodule.nix
      ./declare-bare-submodule-deep-option.nix
    ];
  };
  # checkConfigOutput '^42$' config.bare-submodule.nested ./declare-bare-submodule.nix ./declare-bare-submodule-nested-option.nix ./declare-bare-submodule-deep-option.nix ./define-bare-submodule-values.nix
  testDeclareBareSubmodule3 = checkConfigOutput {
    expected = 42;
    attrPath = [
      "config"
      "bare-submodule"
      "nested"
    ];
    modules = [
      ./declare-bare-submodule.nix
      ./declare-bare-submodule-nested-option.nix
      ./declare-bare-submodule-deep-option.nix
      ./define-bare-submodule-values.nix
    ];
  };

  # checkConfigOutput '^420$' config.bare-submodule.deep ./declare-bare-submodule.nix ./declare-bare-submodule-nested-option.nix ./declare-bare-submodule-deep-option.nix ./define-bare-submodule-values.nix
  testDeclareBareSubmodule4 = checkConfigOutput {
    expected = 420;
    attrPath = [
      "config"
      "bare-submodule"
      "deep"
    ];
    modules = [
      ./declare-bare-submodule.nix
      ./declare-bare-submodule-nested-option.nix
      ./declare-bare-submodule-deep-option.nix
      ./define-bare-submodule-values.nix
    ];
  };
  # checkConfigOutput '^2$' config.bare-submodule.deep ./declare-bare-submodule.nix ./declare-bare-submodule-deep-option.nix ./define-shorthandOnlyDefinesConfig-true.nix
  testDeclareBareSubmodule5 = checkConfigOutput {
    expected = 2;
    attrPath = [
      "config"
      "bare-submodule"
      "deep"
    ];
    modules = [
      ./declare-bare-submodule.nix
      ./declare-bare-submodule-deep-option.nix
      ./define-shorthandOnlyDefinesConfig-true.nix
    ];
  };
  # checkConfigError 'The option .bare-submodule.deep. in .*/declare-bare-submodule-deep-option.nix. is already declared in .*/declare-bare-submodule-deep-option-duplicate.nix' config.bare-submodule.deep ./declare-bare-submodule.nix ./declare-bare-submodule-deep-option.nix  ./declare-bare-submodule-deep-option-duplicate.nix
  testDeclareBareSubmodule6 = checkConfigError {
    expectedError.msg = "The option .bare-submodule.deep. in .*/declare-bare-submodule-deep-option.nix. is already declared in .*/declare-bare-submodule-deep-option-duplicate.nix";
    attrPath = [
      "config"
      "bare-submodule"
      "deep"
    ];
    modules = [
      ./declare-bare-submodule.nix
      ./declare-bare-submodule-deep-option.nix
      ./declare-bare-submodule-deep-option-duplicate.nix
    ];
  };

  # Check that strMatching can be merged
  # checkConfigOutput '^"strMatching.*"$' options.sm.type.name ./strMatching-merge.nix
  testStrMatchingMerge = checkConfigOutput {
    expected = [ ];
    apply = builtins.match "strMatching.*";
    attrPath = [
      "options"
      "sm"
      "type"
      "name"
    ];
    modules = [
      ./strMatching-merge.nix
    ];
  };

  # Check integer types.
  # unsigned
  # checkConfigOutput '^42$' config.value ./declare-int-unsigned-value.nix ./define-value-int-positive.nix
  testDeclareIntUnsignedValue = checkConfigOutput {
    expected = 42;
    attrPath = [
      "config"
      "value"
    ];
    modules = [
      ./declare-int-unsigned-value.nix
      ./define-value-int-positive.nix
    ];
  };
  # checkConfigError 'A definition for option .* is not of type.*unsigned integer.*. Definition values:\n\s*- In .*: -23' config.value ./declare-int-unsigned-value.nix ./define-value-int-negative.nix
  testDeclareIntUnsignedValue2 = checkConfigError {
    expectedError.msg = "A definition for option .* is not of type.*unsigned integer.*. Definition values:";
    attrPath = [
      "config"
      "value"
    ];
    modules = [
      ./declare-int-unsigned-value.nix
      ./define-value-int-negative.nix
    ];
  };
  # positive
  # checkConfigError 'A definition for option .* is not of type.*positive integer.*. Definition values:\n\s*- In .*: 0' config.value ./declare-int-positive-value.nix ./define-value-int-zero.nix
  testDeclareIntPositiveValue = checkConfigError {
    expectedError.msg = "A definition for option .* is not of type.*positive integer.*. Definition values:";
    attrPath = [
      "config"
      "value"
    ];
    modules = [
      ./declare-int-positive-value.nix
      ./define-value-int-zero.nix
    ];
  };
  # between
  # checkConfigOutput '^42$' config.value ./declare-int-between-value.nix ./define-value-int-positive.nix
  testDeclareIntBetweenValue = checkConfigOutput {
    expected = 42;
    attrPath = [
      "config"
      "value"
    ];
    modules = [
      ./declare-int-between-value.nix
      ./define-value-int-positive.nix
    ];
  };
  # checkConfigError 'A definition for option .* is not of type.*between.*-21 and 43.*inclusive.*. Definition values:\n\s*- In .*: -23' config.value ./declare-int-between-value.nix ./define-value-int-negative.nix
  testDeclareIntBetweenValue2 = checkConfigError {
    expectedError.msg = "A definition for option .* is not of type.*between.*-21 and 43.*inclusive.*. Definition values:";
    attrPath = [
      "config"
      "value"
    ];
    modules = [
      ./declare-int-between-value.nix
      ./define-value-int-negative.nix
    ];
  };

  # Check either types
  # types.either
  # checkConfigOutput '^42$' config.value ./declare-either.nix ./define-value-int-positive.nix
  testDeclareEither = checkConfigOutput {
    expected = 42;
    attrPath = [
      "config"
      "value"
    ];
    modules = [
      ./declare-either.nix
      ./define-value-int-positive.nix
    ];
  };
  # checkConfigOutput '^"24"$' config.value ./declare-either.nix ./define-value-string.nix
  testDeclareEither2 = checkConfigOutput {
    expected = "24";
    attrPath = [
      "config"
      "value"
    ];
    modules = [
      ./declare-either.nix
      ./define-value-string.nix
    ];
  };
  # # types.oneOf
  # checkConfigOutput '^42$' config.value ./declare-oneOf.nix ./define-value-int-positive.nix
  testDeclareOneOf = checkConfigOutput {
    expected = 42;
    attrPath = [
      "config"
      "value"
    ];
    modules = [
      ./declare-oneOf.nix
      ./define-value-int-positive.nix
    ];
  };
  # checkConfigOutput '^\[\]$' config.value ./declare-oneOf.nix ./define-value-list.nix
  testDeclareOneOf2 = checkConfigOutput {
    expected = [ ];
    attrPath = [
      "config"
      "value"
    ];
    modules = [
      ./declare-oneOf.nix
      ./define-value-list.nix
    ];
  };
  # checkConfigOutput '^"24"$' config.value ./declare-oneOf.nix ./define-value-string.nix
  testDeclareOneOf3 = checkConfigOutput {
    expected = "24";
    attrPath = [
      "config"
      "value"
    ];
    modules = [
      ./declare-oneOf.nix
      ./define-value-string.nix
    ];
  };

  # Check _module.args.
  # This line sets the positional parameters to "config.enable", "./declare-enable.nix", and "./define-enable-with-custom-arg.nix"
  # set -- config.enable ./declare-enable.nix ./define-enable-with-custom-arg.nix
  # checkConfigError 'while evaluating the module argument .*custom.* in .*define-enable-with-custom-arg.nix.*:' "$@"
  testDefineModuleArgsCustom = checkConfigError {
    expectedError.msg = "while evaluating the module argument .*custom.* in .*define-enable-with-custom-arg.nix.*:";
    attrPath = [
      "config"
      "enable"
    ];
    modules = [
      ./declare-enable.nix
      ./define-enable-with-custom-arg.nix
    ];
  };
  # checkConfigOutput '^true$' "$@" ./define-_module-args-custom.nix
  testDefineModuleArgsCustom2 = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "enable"
    ];
    modules = [
      ./declare-enable.nix
      ./define-enable-with-custom-arg.nix
      ./define-_module-args-custom.nix
    ];
  };

  # Check that using _module.args on imports cause infinite recursions, with
  # the proper error context.
  # set -- "$@" ./define-_module-args-custom.nix ./import-custom-arg.nix
  # checkConfigError 'while evaluating the module argument .*custom.* in .*import-custom-arg.nix.*:' "$@"
  testDefineModuleArgsCustom3 = checkConfigError {
    expectedError.msg = "while evaluating the module argument .*custom.* in .*import-custom-arg.nix.*:";
    attrPath = [
      "config"
      "enable"
    ];
    modules = [
      ./define-_module-args-custom.nix
      ./import-custom-arg.nix
    ];
  };
  # checkConfigError 'infinite recursion encountered' "$@"
  testDefineModuleArgsCustom4 = checkConfigError {
    expectedError.msg = "infinite recursion encountered";
    attrPath = [
      "config"
      "enable"
    ];
    modules = [
      ./define-_module-args-custom.nix
      ./import-custom-arg.nix
    ];
  };

  # Check _module.check.
  # set -- config.enable ./declare-enable.nix ./define-enable.nix ./define-attrsOfSub-foo.nix
  # checkConfigError 'The option .* does not exist. Definition values:\n\s*- In .*' "$@"
  testDefineModuleCheck = checkConfigError {
    expectedError.msg = "The option .* does not exist. Definition values:";
    attrPath = [
      "config"
      "enable"
    ];
    modules = [
      ./declare-enable.nix
      ./define-enable.nix
      ./define-attrsOfSub-foo.nix
    ];
  };
  # checkConfigOutput '^true$' "$@" ./define-module-check.nix
  testDefineModuleCheck2 = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "enable"
    ];
    modules = [
      ./declare-enable.nix
      ./define-enable.nix
      ./define-attrsOfSub-foo.nix
      ./define-module-check.nix
    ];
  };

  # Check coerced value.
  # set --
  # checkConfigOutput '^"42"$' config.value ./declare-coerced-value.nix
  testCoercedValue = checkConfigOutput {
    expected = "42";
    attrPath = [
      "config"
      "value"
    ];
    modules = [
      ./declare-coerced-value.nix
    ];
  };
  # checkConfigOutput '^"24"$' config.value ./declare-coerced-value.nix ./define-value-string.nix
  testCoercedValue2 = checkConfigOutput {
    expected = "24";
    attrPath = [
      "config"
      "value"
    ];
    modules = [
      ./declare-coerced-value.nix
      ./define-value-string.nix
    ];
  };
  # checkConfigError 'A definition for option .* is not.*string or signed integer convertible to it.*. Definition values:\n\s*- In .*: \[ \]' config.value ./declare-coerced-value.nix ./define-value-list.nix
  testCoercedValue3 = checkConfigError {
    expectedError.msg = "A definition for option .* is not.*string or signed integer convertible to it.*. Definition values:";
    attrPath = [
      "config"
      "value"
    ];
    modules = [
      ./declare-coerced-value.nix
      ./define-value-list.nix
    ];
  };

  # Check coerced option merging.
  # checkConfigError 'The option .value. in .*/declare-coerced-value.nix. is already declared in .*/declare-coerced-value-no-default.nix.' config.value ./declare-coerced-value.nix ./declare-coerced-value-no-default.nix
  testCoercedOptionMerge = checkConfigError {
    expectedError.msg = "The option .value. in .*/declare-coerced-value.nix. is already declared in .*/declare-coerced-value-no-default.nix.";
    attrPath = [
      "config"
      "value"
    ];
    modules = [
      ./declare-coerced-value.nix
      ./declare-coerced-value-no-default.nix
    ];
  };

  # Check coerced value with unsound coercion
  # checkConfigOutput '^12$' config.value ./declare-coerced-value-unsound.nix
  testCoercedValueUnsound = checkConfigOutput {
    expected = 12;
    attrPath = [
      "config"
      "value"
    ];
    modules = [
      ./declare-coerced-value-unsound.nix
    ];
  };
  # checkConfigError 'A definition for option .* is not of type .*. Definition values:\n\s*- In .*: "1000"' config.value ./declare-coerced-value-unsound.nix ./define-value-string-bigint.nix
  testCoercedValueUnsound2 = checkConfigError {
    expectedError.msg = "A definition for option .* is not of type .*";
    attrPath = [
      "config"
      "value"
    ];
    modules = [
      ./declare-coerced-value-unsound.nix
      ./define-value-string-bigint.nix
    ];
  };
  # checkConfigError 'toInt: Could not convert .* to int' config.value ./declare-coerced-value-unsound.nix ./define-value-string-arbitrary.nix
  testCoercedValueUnsound3 = checkConfigOutput {
    expected = 12;
    attrPath = [
      "config"
      "value"
    ];
    modules = [
      ./declare-coerced-value-unsound.nix
    ];
  };

  # Check mkAliasOptionModule.
  # checkConfigOutput '^true$' config.enable ./alias-with-priority.nix
  testAliasWithPriority = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "enable"
    ];
    modules = [
      ./alias-with-priority.nix
    ];
  };
  # checkConfigOutput '^true$' config.enableAlias ./alias-with-priority.nix
  testAliasWithPriority2 = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "enableAlias"
    ];
    modules = [
      ./alias-with-priority.nix
    ];
  };
  # checkConfigOutput '^false$' config.enable ./alias-with-priority-can-override.nix
  testAliasWithPriority3 = checkConfigOutput {
    expected = false;
    attrPath = [
      "config"
      "enable"
    ];
    modules = [
      ./alias-with-priority-can-override.nix
    ];
  };

  # checkConfigOutput '^false$' config.enableAlias ./alias-with-priority-can-override.nix
  testAliasWithPriority4 = checkConfigOutput {
    expected = false;
    attrPath = [
      "config"
      "enableAlias"
    ];
    modules = [
      ./alias-with-priority-can-override.nix
    ];
  };

  # Check mkPackageOption
  testMkPackageOption = checkConfigOutput {
    expected = "hello";
    attrPath = [
      "config"
      "package"
      "pname"
    ];
    modules = [
      ./declare-mkPackageOption.nix
    ];
  };

  testNamedPackage = checkConfigOutput {
    expected = "hello";
    attrPath = [
      "config"
      "namedPackage"
      "pname"
    ];
    modules = [
      ./declare-mkPackageOption.nix
    ];
  };

  testNamedPackageDescription = checkConfigOutput {
    expected = "The Hello package to use.";
    attrPath = [
      "options"
      "namedPackage"
      "description"
    ];
    modules = [
      ./declare-mkPackageOption.nix
    ];
  };

  testPathPackage = checkConfigOutput {
    expected = "hello";
    attrPath = [
      "config"
      "pathPackage"
      "pname"
    ];
    modules = [
      ./declare-mkPackageOption.nix
    ];
  };

  testPackageWithExample = checkConfigOutput {
    expected = "pkgs.hello.override { stdenv = pkgs.clangStdenv; }";
    attrPath = [
      "options"
      "packageWithExample"
      "example"
      "text"
    ];
    modules = [
      ./declare-mkPackageOption.nix
    ];
  };

  testPackageWithExtraDescription = checkConfigOutput {
    expected = [ ];
    apply = builtins.match ".*Example extra description..*";
    attrPath = [
      "options"
      "packageWithExtraDescription"
      "description"
    ];
    modules = [
      ./declare-mkPackageOption.nix
    ];
  };

  testUndefinedPackage = checkConfigError {
    expectedError.msg = "The option .undefinedPackage. was accessed but has no value defined. Try setting the option.";
    attrPath = [
      "config"
      "undefinedPackage"
    ];
    modules = [
      ./declare-mkPackageOption.nix
    ];
  };

  testNullablePackage = checkConfigOutput {
    expected = null;
    attrPath = [
      "config"
      "nullablePackage"
    ];
    modules = [
      ./declare-mkPackageOption.nix
    ];
  };

  testNullablePackageWithDefault = checkConfigOutput {
    expected = "null or package";
    attrPath = [
      "options"
      "nullablePackageWithDefault"
      "type"
      "description"
    ];
    modules = [
      ./declare-mkPackageOption.nix
    ];
  };

  testPackageWithPkgsText = checkConfigOutput {
    expected = "myPkgs.hello";
    attrPath = [
      "options"
      "packageWithPkgsText"
      "defaultText"
      "text"
    ];
    modules = [
      ./declare-mkPackageOption.nix
    ];
  };

  testPackageFromOtherSet = checkConfigOutput {
    expected = "hello-other";
    attrPath = [
      "options"
      "packageFromOtherSet"
      "default"
      "pname"
    ];
    modules = [
      ./declare-mkPackageOption.nix
    ];
  };

  # submoduleWith

  ## specialArgs should work
  # checkConfigOutput '^"foo"$' config.submodule.foo ./declare-submoduleWith-special.nix
  testSubmoduleWithSpecial = checkConfigOutput {
    expected = "foo";
    attrPath = [
      "config"
      "submodule"
      "foo"
    ];
    modules = [
      ./declare-submoduleWith-special.nix
    ];
  };

  ## shorthandOnlyDefines config behaves as expected
  # checkConfigOutput '^true$' config.submodule.config ./declare-submoduleWith-shorthand.nix ./define-submoduleWith-shorthand.nix
  testSubmoduleShorthandDefinesConfig = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "submodule"
      "config"
    ];
    modules = [
      ./declare-submoduleWith-shorthand.nix
      ./define-submoduleWith-shorthand.nix
    ];
  };
  # checkConfigError 'is not of type `boolean' config.submodule.config ./declare-submoduleWith-shorthand.nix ./define-submoduleWith-noshorthand.nix
  testSubmoduleShorthandDefinesConfig2 = checkConfigError {
    expectedError.msg = "is not of type `boolean";
    attrPath = [
      "config"
      "submodule"
      "config"
    ];
    modules = [
      ./declare-submoduleWith-shorthand.nix
      ./define-submoduleWith-noshorthand.nix
    ];
  };
  # checkConfigError "In module ..*define-submoduleWith-shorthand.nix., you're trying to define a value of type \`bool'\n\s*rather than an attribute set for the option" config.submodule.config ./declare-submoduleWith-noshorthand.nix ./define-submoduleWith-shorthand.nix
  testSubmoduleShorthandDefinesConfig3 = checkConfigError {
    expectedError.msg = "In module .*define-submoduleWith-shorthand.nix., you're trying to define a value of type `bool'\n *rather than an attribute set for the option";
    attrPath = [
      "config"
      "submodule"
      "config"
    ];
    modules = [
      ./declare-submoduleWith-noshorthand.nix
      ./define-submoduleWith-shorthand.nix
    ];
  };
  # checkConfigOutput '^true$' config.submodule.config ./declare-submoduleWith-noshorthand.nix ./define-submoduleWith-noshorthand.nix
  testSubmoduleShorthandDefinesConfig4 = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "submodule"
      "config"
    ];
    modules = [
      ./declare-submoduleWith-noshorthand.nix
      ./define-submoduleWith-noshorthand.nix
    ];
  };

  ## submoduleWith should merge all modules in one swoop
  # checkConfigOutput '^true$' config.submodule.inner ./declare-submoduleWith-modules.nix
  testSubmoduleWithModules = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "submodule"
      "inner"
    ];
    modules = [
      ./declare-submoduleWith-modules.nix
    ];
  };
  # checkConfigOutput '^true$' config.submodule.outer ./declare-submoduleWith-modules.nix
  testSubmoduleWithModules2 = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "submodule"
      "outer"
    ];
    modules = [
      ./declare-submoduleWith-modules.nix
    ];
  };
  # # Should also be able to evaluate the type name (which evaluates freeformType,
  # # which evaluates all the modules defined by the type)
  # checkConfigOutput '^"submodule"$' options.submodule.type.description ./declare-submoduleWith-modules.nix
  testSubmoduleWithModules3 = checkConfigOutput {
    expected = "submodule";
    attrPath = [
      "options"
      "submodule"
      "type"
      "description"
    ];
    modules = [
      ./declare-submoduleWith-modules.nix
    ];
  };

  ## submodules can be declared using (evalModules {...}).type
  # checkConfigOutput '^true$' config.submodule.inner ./declare-submodule-via-evalModules.nix
  testSubmoduleViaEvalModules = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "submodule"
      "inner"
    ];
    modules = [
      ./declare-submodule-via-evalModules.nix
    ];
  };
  # checkConfigOutput '^true$' config.submodule.outer ./declare-submodule-via-evalModules.nix
  testSubmoduleViaEvalModules2 = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "submodule"
      "outer"
    ];
    modules = [
      ./declare-submodule-via-evalModules.nix
    ];
  };
  # # Should also be able to evaluate the type name (which evaluates freeformType,
  # # which evaluates all the modules defined by the type)
  # checkConfigOutput '^"submodule"$' options.submodule.type.description ./declare-submodule-via-evalModules.nix
  testSubmoduleViaEvalModules3 = checkConfigOutput {
    expected = "submodule";
    attrPath = [
      "options"
      "submodule"
      "type"
      "description"
    ];
    modules = [
      ./declare-submodule-via-evalModules.nix
    ];
  };

  ## Paths should be allowed as values and work as expected
  # checkConfigOutput '^true$' config.submodule.enable ./declare-submoduleWith-path.nix
  testSubmoduleWithPaths = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "submodule"
      "enable"
    ];
    modules = [
      ./declare-submoduleWith-path.nix
    ];
  };

  ## deferredModule
  # default module is merged into nodes.foo
  # checkConfigOutput '"beta"' config.nodes.foo.settingsDict.c ./deferred-module.nix
  testDeferredModule = checkConfigOutput {
    expected = "beta";
    attrPath = [
      "config"
      "nodes"
      "foo"
      "settingsDict"
      "c"
    ];
    modules = [
      ./deferred-module.nix
    ];
  };
  # # errors from the default module are reported with accurate location
  # checkConfigError 'In `the-file-that-contains-the-bad-config.nix, via option default'\'': "bogus"' config.nodes.foo.bottom ./deferred-module.nix
  testDeferredModule2 = checkConfigError {
    expectedError.msg = ".*- In `the-file-that-contains-the-bad-config.nix, via option default': \"bogus\"";
    attrPath = [
      "config"
      "nodes"
      "foo"
      "bottom"
    ];
    modules = [
      ./deferred-module.nix
    ];
  };
  # checkConfigError '.*lib/tests/modules/deferred-module-error.nix, via option deferred [(]:anon-1:anon-1:anon-1[)] does not look like a module.' config.result ./deferred-module-error.nix
  testDeferredModule3 = checkConfigError {
    expectedError.msg = ".*lib/tests/modules/deferred-module-error.nix, via option deferred [(]:anon-1:anon-1:anon-1[)] does not look like a module.";
    attrPath = [
      "config"
      "result"
    ];
    modules = [
      ./deferred-module-error.nix
    ];
  };

  # Check the file location information is propagated into submodules
  # checkConfigOutput the-file.nix config.submodule.internalFiles.0 ./submoduleFiles.nix
  testSubmoduleFiles = checkConfigOutput {
    expected = "the-file.nix";
    apply = builtins.head;
    attrPath = [
      "config"
      "submodule"
      "internalFiles"
    ];
    modules = [
      ./submoduleFiles.nix
    ];
  };

  # Check that disabledModules works recursively and correctly
  # checkConfigOutput '^true$' config.enable ./disable-recursive/main.nix
  testDisableRecursive = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "enable"
    ];
    modules = [
      ./disable-recursive/main.nix
    ];
  };
  # checkConfigOutput '^true$' config.enable ./disable-recursive/{main.nix,disable-foo.nix}
  testDisableRecursive2 = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "enable"
    ];
    modules = [
      ./disable-recursive/main.nix
      ./disable-recursive/disable-foo.nix
    ];
  };
  # checkConfigOutput '^true$' config.enable ./disable-recursive/{main.nix,disable-bar.nix}
  testDisableRecursive3 = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "enable"
    ];
    modules = [
      ./disable-recursive/main.nix
      ./disable-recursive/disable-bar.nix
    ];
  };
  # checkConfigError 'The option .* does not exist. Definition values:\n\s*- In .*: true' config.enable ./disable-recursive/{main.nix,disable-foo.nix,disable-bar.nix}
  testDisableRecursive4 = checkConfigError {
    expectedError.msg = "The option .* does not exist. Definition values:";
    attrPath = [
      "config"
      "enable"
    ];
    modules = [
      ./disable-recursive/main.nix
      ./disable-recursive/disable-foo.nix
      ./disable-recursive/disable-bar.nix
    ];
  };

  # Check that imports can depend on derivations
  # checkConfigOutput '^true$' config.enable ./import-from-store.nix
  testImportFromStore = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "enable"
    ];
    modules = [
      ./import-from-store.nix
    ];
  };

  # Check that configs can be conditional on option existence
  # checkConfigOutput '^true$' config.enable ./define-option-dependently.nix ./declare-enable.nix ./declare-int-positive-value.nix
  testDefineOptionDependently = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "enable"
    ];
    modules = [
      ./define-option-dependently.nix
      ./declare-enable.nix
      ./declare-int-positive-value.nix
    ];
  };
  # checkConfigOutput '^360$' config.value ./define-option-dependently.nix ./declare-enable.nix ./declare-int-positive-value.nix
  testDefineOptionDependently2 = checkConfigOutput {
    expected = 360;
    attrPath = [
      "config"
      "value"
    ];
    modules = [
      ./define-option-dependently.nix
      ./declare-enable.nix
      ./declare-int-positive-value.nix
    ];
  };
  # checkConfigOutput '^7$' config.value ./define-option-dependently.nix ./declare-int-positive-value.nix
  testDefineOptionDependently3 = checkConfigOutput {
    expected = 7;
    attrPath = [
      "config"
      "value"
    ];
    modules = [
      ./define-option-dependently.nix
      ./declare-int-positive-value.nix
    ];
  };
  # checkConfigOutput '^true$' config.set.enable ./define-option-dependently-nested.nix ./declare-enable-nested.nix ./declare-int-positive-value-nested.nix
  testDefineOptionDependentlyNested = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "set"
      "enable"
    ];
    modules = [
      ./define-option-dependently-nested.nix
      ./declare-enable-nested.nix
      ./declare-int-positive-value-nested.nix
    ];
  };
  # checkConfigOutput '^360$' config.set.value ./define-option-dependently-nested.nix ./declare-enable-nested.nix ./declare-int-positive-value-nested.nix
  testDefineOptionDependentlyNested2 = checkConfigOutput {
    expected = 360;
    attrPath = [
      "config"
      "set"
      "value"
    ];
    modules = [
      ./define-option-dependently-nested.nix
      ./declare-enable-nested.nix
      ./declare-int-positive-value-nested.nix
    ];
  };
  # checkConfigOutput '^7$' config.set.value ./define-option-dependently-nested.nix ./declare-int-positive-value-nested.nix
  testDefineOptionDependentlyNested3 = checkConfigOutput {
    expected = 7;
    attrPath = [
      "config"
      "set"
      "value"
    ];
    modules = [
      ./define-option-dependently-nested.nix
      ./declare-int-positive-value-nested.nix
    ];
  };

  # Check attrsOf and lazyAttrsOf. Only lazyAttrsOf should be lazy, and only
  # attrsOf should work with conditional definitions
  # In addition, lazyAttrsOf should honor an options emptyValue
  # checkConfigError "is not lazy" config.isLazy ./declare-attrsOf.nix ./attrsOf-lazy-check.nix
  testAttrsOfLazyCheck = checkConfigError {
    expectedError.msg = "is not lazy";
    attrPath = [
      "config"
      "isLazy"
    ];
    modules = [
      ./declare-attrsOf.nix
      ./attrsOf-lazy-check.nix
    ];
  };
  # checkConfigOutput '^true$' config.isLazy ./declare-lazyAttrsOf.nix ./attrsOf-lazy-check.nix
  testLazyAttrsOfLazyCheck = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "isLazy"
    ];
    modules = [
      ./declare-lazyAttrsOf.nix
      ./attrsOf-lazy-check.nix
    ];
  };
  # checkConfigOutput '^true$' config.conditionalWorks ./declare-attrsOf.nix ./attrsOf-conditional-check.nix
  testAttrsOfConditionalCheck = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "conditionalWorks"
    ];
    modules = [
      ./declare-attrsOf.nix
      ./attrsOf-conditional-check.nix
    ];
  };
  # checkConfigOutput '^false$' config.conditionalWorks ./declare-lazyAttrsOf.nix ./attrsOf-conditional-check.nix
  testLazyAttrsOfConditionalCheck = checkConfigOutput {
    expected = false;
    attrPath = [
      "config"
      "conditionalWorks"
    ];
    modules = [
      ./declare-lazyAttrsOf.nix
      ./attrsOf-conditional-check.nix
    ];
  };
  # checkConfigOutput '^"empty"$' config.value.foo ./declare-lazyAttrsOf.nix ./attrsOf-conditional-check.nix
  testLazyAttrsOfEmptyValue = checkConfigOutput {
    expected = "empty";
    attrPath = [
      "config"
      "value"
      "foo"
    ];
    modules = [
      ./declare-lazyAttrsOf.nix
      ./attrsOf-conditional-check.nix
    ];
  };

  # Check attrsWith type merging
  # checkConfigError 'The option `mergedLazyNonLazy'\'' in `.*'\'' is already declared in `.*'\''\.' options.mergedLazyNonLazy ./lazy-attrsWith.nix
  testLazyAttrsWith = checkConfigError {
    expectedError.msg = "The option `mergedLazyNonLazy' in `.*' is already declared in `.*'\.";
    attrPath = [
      "options"
      "mergedLazyNonLazy"
    ];
    modules = [
      ./lazy-attrsWith.nix
    ];
  };
  # checkConfigOutput '^11$' config.lazyResult ./lazy-attrsWith.nix
  testLazyAttrsWith2 = checkConfigOutput {
    expected = 11;
    attrPath = [
      "config"
      "lazyResult"
    ];
    modules = [
      ./lazy-attrsWith.nix
    ];
  };
  # checkConfigError 'infinite recursion encountered' config.nonLazyResult ./lazy-attrsWith.nix
  testLazyAttrsWith3 = checkConfigError {
    expectedError.msg = "infinite recursion encountered";
    attrPath = [
      "config"
      "nonLazyResult"
    ];
    modules = [
      ./lazy-attrsWith.nix
    ];
  };

  # AttrsWith placeholder tests
  # checkConfigOutput '^"mergedName.<id>.nested"$' config.result ./name-merge-attrsWith-1.nix
  testAttrsWithPlaceholder = checkConfigOutput {
    expected = "mergedName.<id>.nested";
    attrPath = [
      "config"
      "result"
    ];
    modules = [
      ./name-merge-attrsWith-1.nix
    ];
  };
  # checkConfigError 'The option .mergedName. in .*\.nix. is already declared in .*\.nix' config.mergedName ./name-merge-attrsWith-2.nix
  testAttrsWithPlaceholder2 = checkConfigError {
    expectedError.msg = "The option .mergedName. in .*\.nix. is already declared in .*\.nix";
    attrPath = [
      "config"
      "mergedName"
    ];
    modules = [
      ./name-merge-attrsWith-2.nix
    ];
  };

  # Even with multiple assignments, a type error should be thrown if any of them aren't valid
  # checkConfigError 'A definition for option .* is not of type .*' \
  #   config.value ./declare-int-unsigned-value.nix ./define-value-list.nix ./define-value-int-positive.nix
  testMultipleAssignments = checkConfigError {
    expectedError.msg = "A definition for option .* is not of type .*";
    attrPath = [
      "config"
      "value"
    ];
    modules = [
      ./declare-int-unsigned-value.nix
      ./define-value-list.nix
      ./define-value-int-positive.nix
    ];
  };

  ## Freeform modules
  # Assigning without a declared option should work
  # checkConfigOutput '^"24"$' config.value ./freeform-attrsOf.nix ./define-value-string.nix
  testFreeformAttrsOf = checkConfigOutput {
    expected = "24";
    attrPath = [
      "config"
      "value"
    ];
    modules = [
      ./freeform-attrsOf.nix
      ./define-value-string.nix
    ];
  };
  # # Shorthand modules interpret `meta` and `class` as config items
  # checkConfigOutput '^true$' options._module.args.value.result ./freeform-attrsOf.nix ./define-freeform-keywords-shorthand.nix
  testFreeformAttrsOf2 = checkConfigOutput {
    expected = true;
    attrPath = [
      "options"
      "_module"
      "args"
      "value"
      "result"
    ];
    modules = [
      ./freeform-attrsOf.nix
      ./define-freeform-keywords-shorthand.nix
    ];
  };
  # # No freeform assignments shouldn't make it error
  # checkConfigOutput '^{}$' config ./freeform-attrsOf.nix
  testFreeformAttrsOf3 = checkConfigOutput {
    expected = { };
    attrPath = [
      "config"
    ];
    modules = [
      ./freeform-attrsOf.nix
    ];
  };
  # # but only if the type matches
  # checkConfigError 'A definition for option .* is not of type .*' config.value ./freeform-attrsOf.nix ./define-value-list.nix
  testFreeformAttrsOf4 = checkConfigError {
    expectedError.msg = "A definition for option .* is not of type .*";
    attrPath = [
      "config"
      "value"
    ];
    modules = [
      ./freeform-attrsOf.nix
      ./define-value-list.nix
    ];
  };
  # # and properties should be applied
  # checkConfigOutput '^"yes"$' config.value ./freeform-attrsOf.nix ./define-value-string-properties.nix
  testFreeformAttrsOf5 = checkConfigOutput {
    expected = "yes";
    attrPath = [
      "config"
      "value"
    ];
    modules = [
      ./freeform-attrsOf.nix
      ./define-value-string-properties.nix
    ];
  };
  # # Options should still be declarable, and be able to have a type that doesn't match the freeform type
  # checkConfigOutput '^false$' config.enable ./freeform-attrsOf.nix ./define-value-string.nix ./declare-enable.nix
  testFreeformAttrsOf6 = checkConfigOutput {
    expected = false;
    attrPath = [
      "config"
      "enable"
    ];
    modules = [
      ./freeform-attrsOf.nix
      ./define-value-string.nix
      ./declare-enable.nix
    ];
  };
  # checkConfigOutput '^"24"$' config.value ./freeform-attrsOf.nix ./define-value-string.nix ./declare-enable.nix
  testFreeformAttrsOf7 = checkConfigOutput {
    expected = "24";
    attrPath = [
      "config"
      "value"
    ];
    modules = [
      ./freeform-attrsOf.nix
      ./define-value-string.nix
      ./declare-enable.nix
    ];
  };
  # # and this should work too with nested values
  # checkConfigOutput '^false$' config.nest.foo ./freeform-attrsOf.nix ./freeform-nested.nix
  testFreeformAttrsOf8 = checkConfigOutput {
    expected = false;
    attrPath = [
      "config"
      "nest"
      "foo"
    ];
    modules = [
      ./freeform-attrsOf.nix
      ./freeform-nested.nix
    ];
  };
  # checkConfigOutput '^"bar"$' config.nest.bar ./freeform-attrsOf.nix ./freeform-nested.nix
  testFreeformAttrsOf9 = checkConfigOutput {
    expected = "bar";
    attrPath = [
      "config"
      "nest"
      "bar"
    ];
    modules = [
      ./freeform-attrsOf.nix
      ./freeform-nested.nix
    ];
  };
  # # Check whether a declared option can depend on an freeform-typed one
  # checkConfigOutput '^null$' config.foo ./freeform-attrsOf.nix ./freeform-str-dep-unstr.nix
  testFreeformAttrsOf10 = checkConfigOutput {
    expected = null;
    attrPath = [
      "config"
      "foo"
    ];
    modules = [
      ./freeform-attrsOf.nix
      ./freeform-str-dep-unstr.nix
    ];
  };
  # checkConfigOutput '^"24"$' config.foo ./freeform-attrsOf.nix ./freeform-str-dep-unstr.nix ./define-value-string.nix
  testFreeformAttrsOf11 = checkConfigOutput {
    expected = "24";
    attrPath = [
      "config"
      "foo"
    ];
    modules = [
      ./freeform-attrsOf.nix
      ./freeform-str-dep-unstr.nix
      ./define-value-string.nix
    ];
  };
  # # Check whether an freeform-typed value can depend on a declared option, this can only work with lazyAttrsOf
  # checkConfigError 'infinite recursion encountered' config.foo ./freeform-attrsOf.nix ./freeform-unstr-dep-str.nix
  testFreeformAttrsOf12 = checkConfigError {
    expectedError.msg = "infinite recursion encountered";
    attrPath = [
      "config"
      "foo"
    ];
    modules = [
      ./freeform-attrsOf.nix
      ./freeform-unstr-dep-str.nix
    ];
  };
  # checkConfigError 'The option .* was accessed but has no value defined. Try setting the option.' config.foo ./freeform-lazyAttrsOf.nix ./freeform-unstr-dep-str.nix
  testFreeformAttrsOf13 = checkConfigError {
    expectedError.msg = "The option .* was accessed but has no value defined. Try setting the option.";
    attrPath = [
      "config"
      "foo"
    ];
    modules = [
      ./freeform-lazyAttrsOf.nix
      ./freeform-unstr-dep-str.nix
    ];
  };
  # checkConfigOutput '^"24"$' config.foo ./freeform-lazyAttrsOf.nix ./freeform-unstr-dep-str.nix ./define-value-string.nix
  testFreeformAttrsOf14 = checkConfigOutput {
    expected = "24";
    attrPath = [
      "config"
      "foo"
    ];
    modules = [
      ./freeform-lazyAttrsOf.nix
      ./freeform-unstr-dep-str.nix
      ./define-value-string.nix
    ];
  };
  # # submodules in freeformTypes should have their locations annotated
  # checkConfigOutput '/freeform-submodules.nix"$' config.fooDeclarations.0 ./freeform-submodules.nix
  testFreeformAttrsOf15 = checkConfigOutput {
    expected = [ ];
    apply = v: builtins.match ".*/freeform-submodules.nix" (builtins.head v);
    attrPath = [
      "config"
      "fooDeclarations"
    ];
    modules = [
      ./freeform-submodules.nix
    ];
  };
  # # freeformTypes can get merged using `types.type`, including submodules
  # checkConfigOutput '^10$' config.free.xxx.foo ./freeform-submodules.nix
  testFreeformAttrsOf16 = checkConfigOutput {
    expected = 10;
    attrPath = [
      "config"
      "free"
      "xxx"
      "foo"
    ];
    modules = [
      ./freeform-submodules.nix
    ];
  };
  # checkConfigOutput '^10$' config.free.yyy.bar ./freeform-submodules.nix
  testFreeformAttrsOf17 = checkConfigOutput {
    expected = 10;
    attrPath = [
      "config"
      "free"
      "yyy"
      "bar"
    ];
    modules = [
      ./freeform-submodules.nix
    ];
  };

  ## types.anything
  # Check that attribute sets are merged recursively
  # checkConfigOutput '^null$' config.value.foo ./types-anything/nested-attrs.nix
  testTypesAnything = checkConfigOutput {
    expected = null;
    attrPath = [
      "config"
      "value"
      "foo"
    ];
    modules = [
      ./types-anything/nested-attrs.nix
    ];
  };
  # checkConfigOutput '^null$' config.value.l1.foo ./types-anything/nested-attrs.nix
  testTypesAnything2 = checkConfigOutput {
    expected = null;
    attrPath = [
      "config"
      "value"
      "l1"
      "foo"
    ];
    modules = [
      ./types-anything/nested-attrs.nix
    ];
  };
  # checkConfigOutput '^null$' config.value.l1.l2.foo ./types-anything/nested-attrs.nix
  testTypesAnything3 = checkConfigOutput {
    expected = null;
    attrPath = [
      "config"
      "value"
      "l1"
      "l2"
      "foo"
    ];
    modules = [
      ./types-anything/nested-attrs.nix
    ];
  };
  # checkConfigOutput '^null$' config.value.l1.l2.l3.foo ./types-anything/nested-attrs.nix
  testTypesAnything4 = checkConfigOutput {
    expected = null;
    attrPath = [
      "config"
      "value"
      "l1"
      "l2"
      "l3"
      "foo"
    ];
    modules = [
      ./types-anything/nested-attrs.nix
    ];
  };
  # # Attribute sets that are coercible to strings shouldn't be recursed into
  # checkConfigOutput '^"foo"$' config.value.outPath ./types-anything/attrs-coercible.nix
  testTypesAnythingCoercible = checkConfigOutput {
    expected = "foo";
    attrPath = [
      "config"
      "value"
      "outPath"
    ];
    modules = [
      ./types-anything/attrs-coercible.nix
    ];
  };
  # # Multiple lists aren't concatenated together if their definitions are not equal
  # checkConfigError 'The option .* has conflicting definition values' config.value ./types-anything/lists.nix
  testTypesAnythingLists = checkConfigError {
    expectedError.msg = "The option .* has conflicting definition values";
    attrPath = [
      "config"
      "value"
    ];
    modules = [
      ./types-anything/lists.nix
    ];
  };
  # # Check that all equalizable atoms can be used as long as all definitions are equal
  # checkConfigOutput '^0$' config.value.int ./types-anything/equal-atoms.nix
  testTypesAnythingEqualAtoms = checkConfigOutput {
    expected = 0;
    attrPath = [
      "config"
      "value"
      "int"
    ];
    modules = [
      ./types-anything/equal-atoms.nix
    ];
  };
  # checkConfigOutput '^false$' config.value.bool ./types-anything/equal-atoms.nix
  testTypesAnythingEqualAtoms2 = checkConfigOutput {
    expected = false;
    attrPath = [
      "config"
      "value"
      "bool"
    ];
    modules = [
      ./types-anything/equal-atoms.nix
    ];
  };
  # checkConfigOutput '^""$' config.value.string ./types-anything/equal-atoms.nix
  testTypesAnythingEqualAtoms3 = checkConfigOutput {
    expected = "";
    attrPath = [
      "config"
      "value"
      "string"
    ];
    modules = [
      ./types-anything/equal-atoms.nix
    ];
  };
  # checkConfigOutput '^"/[^"]+"$' config.value.path ./types-anything/equal-atoms.nix
  testTypesAnythingEqualAtoms4 = checkConfigOutput {
    expected = ./. + "/types-anything";
    attrPath = [
      "config"
      "value"
      "path"
    ];
    modules = [
      ./types-anything/equal-atoms.nix
    ];
  };
  # checkConfigOutput '^null$' config.value.null ./types-anything/equal-atoms.nix
  testTypesAnythingEqualAtoms5 = checkConfigOutput {
    expected = null;
    attrPath = [
      "config"
      "value"
      "null"
    ];
    modules = [
      ./types-anything/equal-atoms.nix
    ];
  };
  # checkConfigOutput '^0.1$' config.value.float ./types-anything/equal-atoms.nix
  testTypesAnythingEqualAtoms6 = checkConfigOutput {
    expected = 0.1;
    attrPath = [
      "config"
      "value"
      "float"
    ];
    modules = [
      ./types-anything/equal-atoms.nix
    ];
  };
  # checkConfigOutput '^\[1,"a",{"x":null}\]$' config.value.list ./types-anything/equal-atoms.nix
  testTypesAnythingEqualAtoms7 = checkConfigOutput {
    expected = [
      1
      "a"
      { "x" = null; }
    ];
    attrPath = [
      "config"
      "value"
      "list"
    ];
    modules = [
      ./types-anything/equal-atoms.nix
    ];
  };
  # # Functions can't be merged together
  # checkConfigError "The option .value.multiple-lambdas.<function body>. has conflicting option types" config.applied.multiple-lambdas ./types-anything/functions.nix
  testTypesAnythingFunctions = checkConfigError {
    expectedError.msg = "The option .value.multiple-lambdas.<function body>. has conflicting option types";
    attrPath = [
      "config"
      "applied"
      "multiple-lambdas"
    ];
    modules = [
      ./types-anything/functions.nix
    ];
  };
  # checkConfigOutput '^true$' config.valueIsFunction.single-lambda ./types-anything/functions.nix
  testTypesAnythingFunctions2 = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "valueIsFunction"
      "single-lambda"
    ];
    modules = [
      ./types-anything/functions.nix
    ];
  };
  # checkConfigOutput '^null$' config.applied.merging-lambdas.x ./types-anything/functions.nix
  testTypesAnythingFunctions3 = checkConfigOutput {
    expected = null;
    attrPath = [
      "config"
      "applied"
      "merging-lambdas"
      "x"
    ];
    modules = [
      ./types-anything/functions.nix
    ];
  };
  # checkConfigOutput '^null$' config.applied.merging-lambdas.y ./types-anything/functions.nix
  testTypesAnythingFunctions4 = checkConfigOutput {
    expected = null;
    attrPath = [
      "config"
      "applied"
      "merging-lambdas"
      "y"
    ];
    modules = [
      ./types-anything/functions.nix
    ];
  };
  # # Check that all mk* modifiers are applied
  # checkConfigError 'attribute .* not found' config.value.mkiffalse ./types-anything/mk-mods.nix
  testTypesAnythingMkMods = checkConfigError {
    expectedError.msg = "attribute `config.value.mkiffalse";
    attrPath = [
      "config"
      "value"
      "mkiffalse"
    ];
    modules = [
      ./types-anything/mk-mods.nix
    ];
  };
  # checkConfigOutput '^{}$' config.value.mkiftrue ./types-anything/mk-mods.nix
  testTypesAnythingMkMods2 = checkConfigOutput {
    expected = { };
    attrPath = [
      "config"
      "value"
      "mkiftrue"
    ];
    modules = [
      ./types-anything/mk-mods.nix
    ];
  };
  # checkConfigOutput '^1$' config.value.mkdefault ./types-anything/mk-mods.nix
  testTypesAnythingMkMods3 = checkConfigOutput {
    expected = 1;
    attrPath = [
      "config"
      "value"
      "mkdefault"
    ];
    modules = [
      ./types-anything/mk-mods.nix
    ];
  };
  # checkConfigOutput '^{}$' config.value.mkmerge ./types-anything/mk-mods.nix
  testTypesAnythingMkMods4 = checkConfigOutput {
    expected = { };
    attrPath = [
      "config"
      "value"
      "mkmerge"
    ];
    modules = [
      ./types-anything/mk-mods.nix
    ];
  };
  # checkConfigOutput '^true$' config.value.mkbefore ./types-anything/mk-mods.nix
  testTypesAnythingMkMods5 = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "value"
      "mkbefore"
    ];
    modules = [
      ./types-anything/mk-mods.nix
    ];
  };
  # checkConfigOutput '^1$' config.value.nested.foo ./types-anything/mk-mods.nix
  testTypesAnythingMkMods6 = checkConfigOutput {
    expected = 1;
    attrPath = [
      "config"
      "value"
      "nested"
      "foo"
    ];
    modules = [
      ./types-anything/mk-mods.nix
    ];
  };
  # checkConfigOutput '^"baz"$' config.value.nested.bar.baz ./types-anything/mk-mods.nix
  testTypesAnythingMkMods7 = checkConfigOutput {
    expected = "baz";
    attrPath = [
      "config"
      "value"
      "nested"
      "bar"
      "baz"
    ];
    modules = [
      ./types-anything/mk-mods.nix
    ];
  };

  ## types.functionTo
  # checkConfigOutput '^"input is input"$' config.result ./functionTo/trivial.nix
  testFunctionTo = checkConfigOutput {
    expected = "input is input";
    attrPath = [
      "config"
      "result"
    ];
    modules = [
      ./functionTo/trivial.nix
    ];
  };
  # checkConfigOutput '^"a b"$' config.result ./functionTo/merging-list.nix
  testFunctionTo2 = checkConfigOutput {
    expected = "a b";
    attrPath = [
      "config"
      "result"
    ];
    modules = [
      ./functionTo/merging-list.nix
    ];
  };
  # checkConfigError 'A definition for option .fun.<function body>. is not of type .string.. Definition values:\n\s*- In .*wrong-type.nix' config.result ./functionTo/wrong-type.nix
  testFunctionTo3 = checkConfigError {
    expectedError.msg = "A definition for option .fun.<function body>. is not of type .string.. Definition values:";
    attrPath = [
      "config"
      "result"
    ];
    modules = [
      ./functionTo/wrong-type.nix
    ];
  };
  # checkConfigOutput '^"b a"$' config.result ./functionTo/list-order.nix
  testFunctionTo4 = checkConfigOutput {
    expected = "b a";
    attrPath = [
      "config"
      "result"
    ];
    modules = [
      ./functionTo/list-order.nix
    ];
  };
  # checkConfigOutput '^"a c"$' config.result ./functionTo/merging-attrs.nix
  testFunctionTo5 = checkConfigOutput {
    expected = "a c";
    attrPath = [
      "config"
      "result"
    ];
    modules = [
      ./functionTo/merging-attrs.nix
    ];
  };
  # checkConfigOutput '^"a bee"$' config.result ./functionTo/submodule-options.nix
  testFunctionTo6 = checkConfigOutput {
    expected = "a bee";
    attrPath = [
      "config"
      "result"
    ];
    modules = [
      ./functionTo/submodule-options.nix
    ];
  };
  # checkConfigOutput '^"fun.<function body>.a fun.<function body>.b"$' config.optionsResult ./functionTo/submodule-options.nix
  testFunctionTo7 = checkConfigOutput {
    expected = "fun.<function body>.a fun.<function body>.b";
    attrPath = [
      "config"
      "optionsResult"
    ];
    modules = [
      ./functionTo/submodule-options.nix
    ];
  };

  # # moduleType
  # checkConfigOutput '^"a b"$' config.resultFoo ./declare-variants.nix ./define-variant.nix
  testModuleType = checkConfigOutput {
    expected = "a b";
    attrPath = [
      "config"
      "resultFoo"
    ];
    modules = [
      ./declare-variants.nix
      ./define-variant.nix
    ];
  };
  # checkConfigOutput '^"a b y z"$' config.resultFooBar ./declare-variants.nix ./define-variant.nix
  testModuleType2 = checkConfigOutput {
    expected = "a b y z";
    attrPath = [
      "config"
      "resultFooBar"
    ];
    modules = [
      ./declare-variants.nix
      ./define-variant.nix
    ];
  };
  # checkConfigOutput '^"a b c"$' config.resultFooFoo ./declare-variants.nix ./define-variant.nix
  testModuleType3 = checkConfigOutput {
    expected = "a b c";
    attrPath = [
      "config"
      "resultFooFoo"
    ];
    modules = [
      ./declare-variants.nix
      ./define-variant.nix
    ];
  };

  # ## emptyValue's
  # checkConfigOutput "\[\]" config.list.a ./emptyValues.nix
  testEmptyValues = checkConfigOutput {
    expected = [ ];
    attrPath = [
      "config"
      "list"
      "a"
    ];
    modules = [
      ./emptyValues.nix
    ];
  };
  # checkConfigOutput "{}" config.attrs.a ./emptyValues.nix
  testEmptyValues2 = checkConfigOutput {
    expected = { };
    attrPath = [
      "config"
      "attrs"
      "a"
    ];
    modules = [
      ./emptyValues.nix
    ];
  };
  # checkConfigOutput "null" config.null.a ./emptyValues.nix
  testEmptyValues3 = checkConfigOutput {
    expected = null;
    attrPath = [
      "config"
      "null"
      "a"
    ];
    modules = [
      ./emptyValues.nix
    ];
  };
  # checkConfigOutput "{}" config.submodule.a ./emptyValues.nix
  testEmptyValues4 = checkConfigOutput {
    expected = { };
    attrPath = [
      "config"
      "submodule"
      "a"
    ];
    modules = [
      ./emptyValues.nix
    ];
  };
  # # These types don't have empty values
  # checkConfigError 'The option .int.a. was accessed but has no value defined. Try setting the option.' config.int.a ./emptyValues.nix
  testEmptyValues5 = checkConfigError {
    expectedError.msg = "The option .int.a. was accessed but has no value defined. Try setting the option.";
    attrPath = [
      "config"
      "int"
      "a"
    ];
    modules = [
      ./emptyValues.nix
    ];
  };
  # checkConfigError 'The option .nonEmptyList.a. was accessed but has no value defined. Try setting the option.' config.nonEmptyList.a ./emptyValues.nix
  testEmptyValues6 = checkConfigError {
    expectedError.msg = "The option .nonEmptyList.a. was accessed but has no value defined. Try setting the option.";
    attrPath = [
      "config"
      "nonEmptyList"
      "a"
    ];
    modules = [
      ./emptyValues.nix
    ];
  };

  # types.unique
  #   requires a single definition
  # checkConfigError 'The option .examples\.merged. is defined multiple times while it.s expected to be unique' config.examples.merged.a ./types-unique.nix
  testTypesUnique = checkConfigError {
    expectedError.msg = "The option .examples\.merged. is defined multiple times while it.s expected to be unique";
    attrPath = [
      "config"
      "examples"
      "merged"
      "a"
    ];
    modules = [
      ./types-unique.nix
    ];
  };
  # #   user message is printed
  # checkConfigError 'We require a single definition, because seeing the whole value at once helps us maintain critical invariants of our system.' config.examples.merged.a ./types-unique.nix
  testTypesUnique2 = checkConfigError {
    expectedError.msg = "We require a single definition, because seeing the whole value at once helps us maintain critical invariants of our system.";
    attrPath = [
      "config"
      "examples"
      "merged"
      "a"
    ];
    modules = [
      ./types-unique.nix
    ];
  };
  # #   let the inner merge function check the values (on demand)
  # checkConfigError 'A definition for option .examples\.badLazyType\.a. is not of type .string.' config.examples.badLazyType.a ./types-unique.nix
  testTypesUnique3 = checkConfigError {
    expectedError.msg = "A definition for option .examples\.badLazyType\.a. is not of type .string.";
    attrPath = [
      "config"
      "examples"
      "badLazyType"
      "a"
    ];
    modules = [
      ./types-unique.nix
    ];
  };
  # #   overriding still works (unlike option uniqueness)
  # checkConfigOutput '^"bee"$' config.examples.override.b ./types-unique.nix
  testTypesUnique4 = checkConfigOutput {
    expected = "bee";
    attrPath = [
      "config"
      "examples"
      "override"
      "b"
    ];
    modules = [
      ./types-unique.nix
    ];
  };

  ## types.raw
  # checkConfigOutput '^true$' config.unprocessedNestingEvaluates.success ./raw.nix
  testTypesRaw = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "unprocessedNestingEvaluates"
      "success"
    ];
    modules = [
      ./raw.nix
    ];
  };
  # checkConfigOutput "10" config.processedToplevel ./raw.nix
  testTypesRaw2 = checkConfigOutput {
    expected = 10;
    attrPath = [
      "config"
      "processedToplevel"
    ];
    modules = [
      ./raw.nix
    ];
  };
  # checkConfigError "The option .multiple. is defined multiple times" config.multiple ./raw.nix
  testTypesRaw3 = checkConfigError {
    expectedError.msg = "The option .multiple. is defined multiple times";
    attrPath = [
      "config"
      "multiple"
    ];
    modules = [
      ./raw.nix
    ];
  };
  # checkConfigOutput "bar" config.priorities ./raw.nix
  testTypesRaw4 = checkConfigOutput {
    expected = "bar";
    attrPath = [
      "config"
      "priorities"
    ];
    modules = [
      ./raw.nix
    ];
  };

  ## Option collision
  # checkConfigError \
  #   'The option .set. in module .*/declare-set.nix. would be a parent of the following options, but its type .attribute set of signed integer. does not support nested options.\n\s*- option[(]s[)] with prefix .set.enable. in module .*/declare-enable-nested.nix.' \
  #   config.set \
  #   ./declare-set.nix ./declare-enable-nested.nix
  testOptionCollision = checkConfigError {
    expectedError.msg = "The option .set. in module .*/declare-set.nix. would be a parent of the following options, but its type .attribute set of signed integer. does not support nested options.\n *- option[(]s[)] with prefix .set.enable. in module .*/declare-enable-nested.nix.";
    attrPath = [
      "config"
      "set"
    ];
    modules = [
      ./declare-set.nix
      ./declare-enable-nested.nix
    ];
  };

  # # Options: accidental use of an option-type instead of option (or other tagged type; unlikely)
  # checkConfigError 'In module .*/options-type-error-typical.nix: expected an option declaration at option path .result. but got an attribute set with type option-type' config.result ./options-type-error-typical.nix
  testOptionsTypeErrors = checkConfigError {
    expectedError.msg = "In module .*/options-type-error-typical.nix: expected an option declaration at option path .result. but got an attribute set with type option-type";
    attrPath = [
      "config"
      "result"
    ];
    modules = [
      ./options-type-error-typical.nix
    ];
  };
  # checkConfigError 'In module .*/options-type-error-typical-nested.nix: expected an option declaration at option path .result.here. but got an attribute set with type option-type' config.result.here ./options-type-error-typical-nested.nix
  testOptionsTypeErrors2 = checkConfigError {
    expectedError.msg = "In module .*/options-type-error-typical-nested.nix: expected an option declaration at option path .result.here. but got an attribute set with type option-type";
    attrPath = [
      "config"
      "result"
      "here"
    ];
    modules = [
      ./options-type-error-typical-nested.nix
    ];
  };
  # checkConfigError 'In module .*/options-type-error-configuration.nix: expected an option declaration at option path .result. but got an attribute set with type configuration' config.result ./options-type-error-configuration.nix
  testOptionsTypeErrors3 = checkConfigError {
    expectedError.msg = "In module .*/options-type-error-configuration.nix: expected an option declaration at option path .result. but got an attribute set with type configuration";
    attrPath = [
      "config"
      "result"
    ];
    modules = [
      ./options-type-error-configuration.nix
    ];
  };
  # # Check that that merging of option collisions doesn't depend on type being set
  # checkConfigError 'The option .group..*would be a parent of the following options, but its type .<no description>. does not support nested options.\n\s*- option.s. with prefix .group.enable..*' config.group.enable ./merge-typeless-option.nix
  testMergeTypelessOptionCollision = checkConfigError {
    expectedError.msg = "The option .group..*would be a parent of the following options, but its type .<no description>. does not support nested options.\n *- option.s. with prefix .group.enable..*";
    attrPath = [
      "config"
      "group"
      "enable"
    ];
    modules = [
      ./merge-typeless-option.nix
    ];
  };

  # # Test that types.optionType merges types correctly
  # checkConfigOutput '^10$' config.theOption.int ./optionTypeMerging.nix
  testOptionTypeMerging = checkConfigOutput {
    expected = 10;
    attrPath = [
      "config"
      "theOption"
      "int"
    ];
    modules = [
      ./optionTypeMerging.nix
    ];
  };
  # checkConfigOutput '^"hello"$' config.theOption.str ./optionTypeMerging.nix
  testOptionTypeMerging2 = checkConfigOutput {
    expected = "hello";
    attrPath = [
      "config"
      "theOption"
      "str"
    ];
    modules = [
      ./optionTypeMerging.nix
    ];
  };

  # # Test that types.optionType correctly annotates option locations
  # checkConfigError 'The option .theOption.nested. in .other.nix. is already declared in .optionTypeFile.nix.' config.theOption.nested ./optionTypeFile.nix
  testOptionTypeFile = checkConfigError {
    expectedError.msg = "The option .theOption.nested. in .other.nix. is already declared in .optionTypeFile.nix.";
    attrPath = [
      "config"
      "theOption"
      "nested"
    ];
    modules = [
      ./optionTypeFile.nix
    ];
  };

  # # Test that types.optionType leaves types untouched as long as they don't need to be merged
  # checkConfigOutput 'ok' config.freeformItems.foo.bar ./adhoc-freeformType-survives-type-merge.nix
  testOptionTypeSurvivesTypeMerge = checkConfigOutput {
    expected = "ok";
    attrPath = [
      "config"
      "freeformItems"
      "foo"
      "bar"
    ];
    modules = [
      ./adhoc-freeformType-survives-type-merge.nix
    ];
  };

  # # Test that specifying both functor.wrapped and functor.payload isn't allowed
  # checkConfigError 'Type foo defines both `functor.payload` and `functor.wrapped` at the same time, which is not supported.' config.result ./default-type-merge-both.nix
  testDeprecatedFunctorWrapped = checkConfigError {
    expectedError.msg = "Type foo defines both `functor.payload` and `functor.wrapped` at the same time, which is not supported.";
    attrPath = [
      "config"
      "result"
    ];
    modules = [
      ./default-type-merge-both.nix
    ];
  };

  # Anonymous submodules don't get nixed by import resolution/deduplication
  # because of an `extendModules` bug, issue 168767.
  # checkConfigOutput '^1$' config.sub.specialisation.value ./extendModules-168767-imports.nix
  testExtendModules168767 = checkConfigOutput {
    expected = 1;
    attrPath = [
      "config"
      "sub"
      "specialisation"
      "value"
    ];
    modules = [
      ./extendModules-168767-imports.nix
    ];
  };

  # Class checks, evalModules
  # checkConfigOutput '^{}$' config.ok.config ./class-check.nix
  testClassCheck = checkConfigOutput {
    expected = { };
    attrPath = [
      "config"
      "ok"
      "config"
    ];
    modules = [
      ./class-check.nix
    ];
  };
  # checkConfigOutput '"nixos"' config.ok.class ./class-check.nix
  testClassCheck2 = checkConfigOutput {
    expected = "nixos";
    attrPath = [
      "config"
      "ok"
      "class"
    ];
    modules = [
      ./class-check.nix
    ];
  };
  # checkConfigError 'The module `.*/module-class-is-darwin.nix`.*?expects class "nixos".' config.fail.config ./class-check.nix
  testClassCheck3 = checkConfigError {
    expectedError.msg = "The module `.*/module-class-is-darwin.nix`.*?expects class \"nixos\".";
    attrPath = [
      "config"
      "fail"
      "config"
    ];
    modules = [
      ./class-check.nix
    ];
  };
  # checkConfigError 'The module `foo.nix#darwinModules.default`.*?expects class "nixos".' config.fail-anon.config ./class-check.nix
  testClassCheck4 = checkConfigError {
    expectedError.msg = "The module `foo.nix#darwinModules.default`.*?expects class \"nixos\".";
    attrPath = [
      "config"
      "fail-anon"
      "config"
    ];
    modules = [
      ./class-check.nix
    ];
  };

  # Class checks, submoduleWith
  # checkConfigOutput '^{}$' config.sub.nixosOk ./class-check.nix
  testClassCheckSubmodule = checkConfigOutput {
    expected = { };
    attrPath = [
      "config"
      "sub"
      "nixosOk"
    ];
    modules = [
      ./class-check.nix
    ];
  };
  # checkConfigError 'The module `.*/module-class-is-darwin.nix`.*?expects class "nixos".' config.sub.nixosFail.config ./class-check.nix
  testClassCheckSubmodule2 = checkConfigError {
    expectedError.msg = "The module `.*/module-class-is-darwin.nix`.*?expects class \"nixos\".";
    attrPath = [
      "config"
      "sub"
      "nixosFail"
      "config"
    ];
    modules = [
      ./class-check.nix
    ];
  };

  # # submoduleWith type merge with different class
  # checkConfigError 'A submoduleWith option is declared multiple times with conflicting class values "darwin" and "nixos".' config.sub.mergeFail.config ./class-check.nix
  testClassCheckSubmodule3 = checkConfigError {
    expectedError.msg = "A submoduleWith option is declared multiple times with conflicting class values \"darwin\" and \"nixos\".";
    attrPath = [
      "config"
      "sub"
      "mergeFail"
      "config"
    ];
    modules = [
      ./class-check.nix
    ];
  };

  # # _type check
  # checkConfigError 'Expected a module, but found a value of type .*"flake".*, while trying to load a module into .*/module-imports-_type-check.nix' config.ok.config ./module-imports-_type-check.nix
  testModuleImportsTypeCheck = checkConfigError {
    expectedError.msg = "Expected a module, but found a value of type .*\"flake\".*, while trying to load a module into .*/module-imports-_type-check.nix";
    attrPath = [
      "config"
      "ok"
      "config"
    ];
    modules = [
      ./module-imports-_type-check.nix
    ];
  };
  # checkConfigOutput '^true$' config.enable ./declare-enable.nix ./define-enable-with-top-level-mkIf.nix
  testModuleTypeDeclareEnable = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "enable"
    ];
    modules = [
      ./declare-enable.nix
      ./define-enable-with-top-level-mkIf.nix
    ];
  };
  # checkConfigError 'Expected a module, but found a value of type .*"configuration".*, while trying to load a module into .*/import-configuration.nix.' config ./import-configuration.nix
  testModuleTypeImportConfiguration = checkConfigError {
    expectedError.msg = "Expected a module, but found a value of type .*\"configuration\".*, while trying to load a module into .*/import-configuration.nix.";
    attrPath = [
      "config"
    ];
    modules = [
      ./import-configuration.nix
    ];
  };
  # checkConfigError 'please only import the modules that make up the configuration' config ./import-configuration.nix
  testModuleTypeImportConfiguration2 = checkConfigError {
    expectedError.msg = "please only import the modules that make up the configuration";
    attrPath = [
      "config"
    ];
    modules = [
      ./import-configuration.nix
    ];
  };

  # doRename works when `warnings` does not exist.
  # checkConfigOutput '^1234$' config.c.d.e ./doRename-basic.nix
  testDoRename = checkConfigOutput {
    expected = 1234;
    attrPath = [
      "config"
      "c"
      "d"
      "e"
    ];
    modules = [
      ./doRename-basic.nix
    ];
  };
  # # doRename adds a warning.
  # checkConfigOutput '^"The option `a\.b. defined in `.*/doRename-warnings\.nix. has been renamed to `c\.d\.e.\."$' \
  #   config.result \
  #   ./doRename-warnings.nix
  testDoRenameWarnings = checkConfigOutput {
    expected = [ ];
    apply = builtins.match "The option .a\.b. defined in .*/doRename-warnings\.nix. has been renamed to .c\.d\.e.*";
    attrPath = [
      "config"
      "result"
    ];
    modules = [
      ./doRename-warnings.nix
    ];
  };
  # checkConfigOutput "^true$" config.result ./doRename-condition.nix ./doRename-condition-enable.nix
  testDoRenameCondition = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "result"
    ];
    modules = [
      ./doRename-condition.nix
      ./doRename-condition-enable.nix
    ];
  };
  # checkConfigOutput "^true$" config.result ./doRename-condition.nix ./doRename-condition-no-enable.nix
  testDoRenameCondition2 = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "result"
    ];
    modules = [
      ./doRename-condition.nix
      ./doRename-condition-no-enable.nix
    ];
  };
  # checkConfigOutput "^true$" config.result ./doRename-condition.nix ./doRename-condition-migrated.nix
  testDoRenameCondition3 = checkConfigOutput {
    expected = true;
    attrPath = [
      "config"
      "result"
    ];
    modules = [
      ./doRename-condition.nix
      ./doRename-condition-migrated.nix
    ];
  };

  # Anonymous modules get deduplicated by key
  # checkConfigOutput '^"pear"$' config.once.raw ./merge-module-with-key.nix
  testAnonymousModuleDeduplication = checkConfigOutput {
    expected = "pear";
    attrPath = [
      "config"
      "once"
      "raw"
    ];
    modules = [
      ./merge-module-with-key.nix
    ];
  };
  # checkConfigOutput '^"pear\\npear"$' config.twice.raw ./merge-module-with-key.nix
  testAnonymousModuleDeduplication2 = checkConfigOutput {
    expected = "pear\npear";
    attrPath = [
      "config"
      "twice"
      "raw"
    ];
    modules = [
      ./merge-module-with-key.nix
    ];
  };

  # # Declaration positions
  # # Line should be present for direct options
  # checkConfigOutput '^14$' options.imported.line14.declarationPositions.0.line ./declaration-positions.nix
  testCheckDeclarationPositions = checkConfigOutput {
    expected = 14;
    apply = v: (builtins.head v).line;
    attrPath = [
      "options"
      "imported"
      "line14"
      "declarationPositions"
    ];
    modules = [
      ./declaration-positions.nix
    ];
  };
  # checkConfigOutput '/declaration-positions.nix"$' options.imported.line14.declarationPositions.0.file ./declaration-positions.nix
  testCheckDeclarationPositions2 = checkConfigOutput {
    expected = builtins.toString ./declaration-positions.nix;
    apply = v: (builtins.head v).file;
    attrPath = [
      "options"
      "imported"
      "line14"
      "declarationPositions"
    ];
    modules = [
      ./declaration-positions.nix
    ];
  };
  # # Generated options may not have line numbers but they will at least get the
  # # right file
  # checkConfigOutput '/declaration-positions.nix"$' options.generated.line22.declarationPositions.0.file ./declaration-positions.nix
  testCheckDeclarationPositions3 = checkConfigOutput {
    expected = builtins.toString ./declaration-positions.nix;
    apply = v: (builtins.head v).file;
    attrPath = [
      "options"
      "generated"
      "line22"
      "declarationPositions"
    ];
    modules = [
      ./declaration-positions.nix
    ];
  };
  # checkConfigOutput '^null$' options.generated.line22.declarationPositions.0.line ./declaration-positions.nix
  testCheckDeclarationPositions4 = checkConfigOutput {
    expected = null;
    apply = v: (builtins.head v).line;
    attrPath = [
      "options"
      "generated"
      "line22"
      "declarationPositions"
    ];
    modules = [
      ./declaration-positions.nix
    ];
  };
  # # Submodules don't break it
  # checkConfigOutput '^45$' config.submoduleLine38.submodDeclLine45.0.line ./declaration-positions.nix
  testCheckDeclarationPositions5 = checkConfigOutput {
    expected = 45;
    apply = v: (builtins.head v).line;
    attrPath = [
      "config"
      "submoduleLine38"
      "submodDeclLine45"
    ];
    modules = [
      ./declaration-positions.nix
    ];
  };
  # checkConfigOutput '/declaration-positions.nix"$' config.submoduleLine38.submodDeclLine45.0.file ./declaration-positions.nix
  testCheckDeclarationPositions6 = checkConfigOutput {
    expected = builtins.toString ./declaration-positions.nix;
    apply = v: (builtins.head v).file;
    attrPath = [
      "config"
      "submoduleLine38"
      "submodDeclLine45"
    ];
    modules = [
      ./declaration-positions.nix
    ];
  };
  # # New options under freeform submodules get collected into the parent submodule
  # # (consistent with .declarations behaviour, but weird; notably appears in system.build)
  # checkConfigOutput '^38|27$' options.submoduleLine38.declarationPositions.0.line ./declaration-positions.nix
  testCheckDeclarationPositions7 = checkConfigOutput {
    expected = true;
    apply =
      v:
      let
        line = (builtins.head v).line;
      in
      builtins.elem line [
        27
        38
      ];
    attrPath = [
      "options"
      "submoduleLine38"
      "declarationPositions"
    ];
    modules = [
      ./declaration-positions.nix
    ];
  };
  # checkConfigOutput '^38|27$' options.submoduleLine38.declarationPositions.1.line ./declaration-positions.nix
  testCheckDeclarationPositions8 = checkConfigOutput {
    expected = true;
    apply =
      v:
      let
        line = (builtins.elemAt v 1).line;
      in
      builtins.elem line [
        27
        38
      ];
    attrPath = [
      "options"
      "submoduleLine38"
      "declarationPositions"
    ];
    modules = [
      ./declaration-positions.nix
    ];
  };
  # # nested options work
  # checkConfigOutput '^34$' options.nested.nestedLine34.declarationPositions.0.line ./declaration-positions.nix
  testCheckDeclarationPositions9 = checkConfigOutput {
    expected = 34;
    apply = v: (builtins.head v).line;
    attrPath = [
      "options"
      "nested"
      "nestedLine34"
      "declarationPositions"
    ];
    modules = [
      ./declaration-positions.nix
    ];
  };

}
