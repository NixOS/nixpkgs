let
  lib = import ../default.nix;

  inherit (lib.attrsets)
    associateWithAttrPath
    associateWithAttrPath'
    ;
in

lib.runTests {
  # FIXME there weren't any lib.attrsets tests until I(@Atemu) added
  # associateWithAttrPath' and pathOperationsToAttrPaths; the other functions
  # need to be tested too.

  testAssociateWithAttrPathImmediate = {
    expr = associateWithAttrPath' [ ] "foo" "from";
    expected = [
      {
        name = "from";
        value = [ "foo" ];
      }
    ];
  };
  testAssociateWithAttrPathNested1 = {
    expr = associateWithAttrPath' [ ] "foo" { bar = "from"; };
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
  testAssociateWithAttrPathNested2 = {
    expr = associateWithAttrPath' [ ] "foo" { bar.baz = "from"; };
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
  testAssociateWithAttrPathNestedInSame = {
    expr = associateWithAttrPath' [ ] "foo" {
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
  testAssociateWithAttrPathCommonPrefix = {
    expr = associateWithAttrPath' [ ] "foo" {
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
    expr = associateWithAttrPath {
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
