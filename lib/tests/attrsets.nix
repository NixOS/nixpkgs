let
  lib = import ../default.nix;

  inherit (lib.attrsets)
    associateWithAttrPath'
    associateWithAttrPath
    associateWithAttrPathMultiple
    ;
in

lib.runTests {
  # FIXME there weren't any lib.attrsets tests until I(@Atemu) added
  # associateWithAttrPath; the other functions need to be tested too.

  testAssociateWithAttrPathImmediate = {
    expr = associateWithAttrPathMultiple [ ] "foo" "from";
    expected = [
      {
        name = "from";
        value = [ "foo" ];
      }
    ];
  };
  testAssociateWithAttrPathNested1 = {
    expr = associateWithAttrPathMultiple [ ] "foo" { bar = "from"; };
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
    expr = associateWithAttrPathMultiple [ ] "foo" { bar.baz = "from"; };
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
    expr = associateWithAttrPathMultiple [ ] "foo" {
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
    expr = associateWithAttrPathMultiple [ ] "foo" {
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
