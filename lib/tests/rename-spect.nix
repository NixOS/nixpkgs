let
  lib = import ../default.nix;
in

lib.runTests {
  testProcessAttrImmediate = {
    expr = lib.modules.processAttr [ ] "foo" "from";
    expected = [
      {
        name = "from";
        value = [ "foo" ];
      }
    ];
  };
  testProcessAttrNested1 = {
    expr = lib.modules.processAttr [ ] "foo" { bar = "from"; };
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
  testProcessAttrNestedInSame = {
    expr = lib.modules.processAttr [ ] "foo" {
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
  testProcessAttrNestedInSameDeeper = {
    expr = lib.modules.processAttr [ ] "foo" {
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
  testRenameSpec = {
    expr = lib.modules.transformRenameSpec {
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
