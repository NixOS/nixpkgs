let
  lib = import ../default.nix;

  inherit (lib.attrsets)
    pathOperationsToAttrPaths
    pathOperationsToAttrPaths'
    ;
in

lib.runTests {
  # FIXME there weren't any lib.attrsets tests until I(@Atemu) added
  # pathOperationsToAttrPaths; the other functions need to be tested too.

  testPathOperationsToAttrPaths'Immediate = {
    expr = pathOperationsToAttrPaths' [ ] "foo" "from";
    expected = [
      {
        name = "from";
        value = [ "foo" ];
      }
    ];
  };
  testPathOperationsToAttrPaths'Nested1 = {
    expr = pathOperationsToAttrPaths' [ ] "foo" { bar = "from"; };
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
    expr = pathOperationsToAttrPaths' [ ] "foo" { bar.baz = "from"; };
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
    expr = pathOperationsToAttrPaths' [ ] "foo" {
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
    expr = pathOperationsToAttrPaths' [ ] "foo" {
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
    expr = pathOperationsToAttrPaths {
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
