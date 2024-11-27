let
  lib = import ../default.nix;
in

lib.runTests {
  testPathOperationsToAttrPaths'Immediate = {
    expr = lib.attrsets.pathOperationsToAttrPaths' [ ] "foo" "from";
    expected = [
      {
        name = "from";
        value = [ "foo" ];
      }
    ];
  };
  testPathOperationsToAttrPaths'Nested1 = {
    expr = lib.attrsets.pathOperationsToAttrPaths' [ ] "foo" { bar = "from"; };
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
  testPathOperationsToAttrPaths'Nested2 = {
    expr = lib.attrsets.pathOperationsToAttrPaths' [ ] "foo" { bar.baz = "from"; };
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
  testPathOperationsToAttrPaths'NestedInSame = {
    expr = lib.attrsets.pathOperationsToAttrPaths' [ ] "foo" {
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
  testPathOperationsToAttrPaths'CommonPrefix = {
    expr = lib.attrsets.pathOperationsToAttrPaths' [ ] "foo" {
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
    expr = lib.attrsets.pathOperationsToAttrPaths {
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
