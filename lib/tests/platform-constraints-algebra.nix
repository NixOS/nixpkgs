let
  lib = import ./..;

  exampleSystem = lib.systems.elaborate "aarch64-darwin";
in
lib.runTests (
  {
    test_evalPatternMatch_AND = {
      expr =
        with lib.platform.constraints;
        lib.platform.evalConstraints exampleSystem (AND [
          is64bit
          is32bit
        ]);
      expected = false;
    };
    test_evalPatternMatch_AND_is_noop = {
      expr =
        with lib.platform.constraints;
        lib.platform.evalConstraints exampleSystem (AND [ is64bit ]);
      expected = true;
    };
    test_evalPatternMatch_OR = {
      expr =
        with lib.platform.constraints;
        lib.platform.evalConstraints exampleSystem (OR [
          is64bit
          is32bit
        ]);
      expected = true;
    };
    test_evalPatternMatch_OR_is_noop = {
      expr =
        with lib.platform.constraints;
        lib.platform.evalConstraints exampleSystem (OR [ is64bit ]);
      expected = true;
    };
    test_evalPatternMatch_NOT = {
      expr =
        with lib.platform.constraints;
        lib.platform.evalConstraints exampleSystem (NOT is64bit);
      expected = false;
    };

    test_evalPatternMatch_ANY = {
      expr = with lib.platform.constraints; lib.platform.evalConstraints exampleSystem ANY;
      expected = true;
    };
    test_evalPatternMatch_NONE = {
      expr = with lib.platform.constraints; lib.platform.evalConstraints exampleSystem NONE;
      expected = false;
    };
  }
  //
    lib.mapAttrs'
      (
        system: expected:
        lib.nameValuePair "test_evalPatternMatch_nested_combination_${system}" {
          expr =
            with lib.platform.constraints;
            lib.platform.evalConstraints (lib.systems.elaborate system) (AND [
              (NOT is32bit)
              (OR [
                isLinux
                isFreeBSD
              ])
            ]);
          inherit expected;
        }
      )
      {
        aarch64-darwin = false;
        aarch64-linux = true;
        armv7l-linux = false;
        armv7l-darwin = false;
        x86_64-linux = true;
        x86_64-freebsd = true;
        aarch64-freebsd = true;
        i686-freebsd = false;
      }
)
