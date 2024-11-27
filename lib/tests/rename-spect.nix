let
  lib = import ../default.nix;
in

lib.runTests {
  testPathOperationsToAttrPaths'_Immediate = {
    expr = lib.modules.pathOperationsToAttrPaths' [ ] "foo" "from";
    expected = [
      {
        name = "from";
        value = [ "foo" ];
      }
    ];
  };
  testPathOperationsToAttrPaths'_Nested1 = {
    expr = lib.modules.pathOperationsToAttrPaths' [ ] "foo" { bar = "from"; };
    expected = [
      {
        name = "from";
        value = [
          "foo"
          "bar"
        ];
      }
    ];
  };
  testPathOperationsToAttrPaths'_Nested2 = {
    expr = lib.modules.pathOperationsToAttrPaths' [ ] "foo" { bar.baz = "from"; };
    expected = [
      {
        name = "from";
        value = [
          "foo"
          "bar"
          "baz"
        ];
      }
    ];
  };
  testPathOperationsToAttrPaths'_NestedInSame = {
    expr = lib.modules.pathOperationsToAttrPaths' [ ] "foo" {
      bar = "from";
      baz = "to";
    };
    expected = [
      {
        name = "from";
        value = [
          "foo"
          "bar"
        ];
      }
      {
        name = "to";
        value = [
          "foo"
          "baz"
        ];
      }
    ];
  };
  testPathOperationsToAttrPaths'_commonPrefix = {
    expr = lib.modules.pathOperationsToAttrPaths' [ ] "foo" {
      common.prefix.bar = "from";
      common.prefix.baz = "to";
    };
    expected = [
      {
        name = "from";
        value = [
          "foo"
          "common"
          "prefix"
          "bar"
        ];
      }
      {
        name = "to";
        value = [
          "foo"
          "common"
          "prefix"
          "baz"
        ];
      }
    ];
  };
  testPathOperationsToAttrPaths = {
    expr = lib.modules.pathOperationsToAttrPaths {
      foo.bar = "from";
      baz.quux = "to";
    };
    expected = {
      from = [
        "foo"
        "bar"
      ];
      to = [
        "baz"
        "quux"
      ];
    };
  };
}
