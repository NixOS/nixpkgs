{ config, lib, ... }:
let
  inherit (lib.types) attrsOf bool either int lazyAttrsOf listOf str submodule;
  testSubmodule = submodule {
    options = {
      x = lib.mkOption { type = listOf int; };
      y = lib.mkOption { type = int; };
      z = lib.mkOption { type = either int str; };
    };
  };
  testAttrDefs = lib.mkMerge [
    {
      a.x = lib.mkBefore [ 0 ];
      b.y = lib.mkForce 3;
      b.z = "4";
    }
    (lib.modules.mkForAllItems {
      x = [ 1 ];
      y = 2;
    })
    (lib.modules.mkForAllItems (name: {
      z = lib.mkDefault name;
    }))
  ];
  testListDefs = lib.mkMerge [
    [
      {
        x = lib.mkBefore [ 0 ];
      }
      {
        y = lib.mkForce 3;
        z = "4";
      }
    ]
    (lib.modules.mkForAllItems {
      x = [ 1 ];
      y = 2;
    })
    (lib.modules.mkForAllItems (name: {
      z = lib.mkDefault name;
    }))
  ];
  expected = {
    a = {
      x = [ 0 1 ];
      y = 2;
      z = "a";
    };
    b = {
      x = [ 1 ];
      y = 3;
      z = "4";
    };
  };
in
{
  options = {
    testAttrs = lib.mkOption { type = attrsOf testSubmodule; };
    testLazyAttrs = lib.mkOption { type = lazyAttrsOf testSubmodule; };
    testList = lib.mkOption { type = listOf testSubmodule; };
    result = lib.mkOption { type = bool; };
  };

  config = {
    testAttrs = testAttrDefs;
    testLazyAttrs = testAttrDefs;
    testList = testListDefs;

    result =
      config.testAttrs == expected &&
      config.testLazyAttrs == expected &&
      config.testList == [ (expected.a // { z = 1; }) expected.b ];
  };
}
