{ config, lib, ... }:
let
  inherit (builtins)
    storeDir
    ;
  inherit (lib)
    types
    mkOption
    ;
in
{
  options = {
    check = mkOption { };
    # NB: types are tested in multiple places, so this list is far from exhaustive
    pathInStore = mkOption { type = types.lazyAttrsOf types.pathInStore; };
    attrNamesToTrue = mkOption { type = types.lazyAttrsOf types.attrNamesToTrue; };
  };
  config = {
    pathInStore.ok1 = "${storeDir}/0lz9p8xhf89kb1c1kk6jxrzskaiygnlh-bash-5.2-p15.drv";
    pathInStore.ok2 = "${storeDir}/0fb3ykw9r5hpayd05sr0cizwadzq1d8q-bash-5.2-p15";
    pathInStore.ok3 = "${storeDir}/0fb3ykw9r5hpayd05sr0cizwadzq1d8q-bash-5.2-p15/bin/bash";
    pathInStore.bad1 = "";
    pathInStore.bad2 = "${storeDir}";
    pathInStore.bad3 = "${storeDir}/";
    pathInStore.bad4 = "${storeDir}/.links"; # technically true, but not reasonable
    pathInStore.bad5 = "/foo/bar";
    attrNamesToTrue.justNames = [
      "a"
      "b"
      "c"
    ];
    attrNamesToTrue.mixed = lib.mkMerge [
      {
        a = true;
        b = false;
      }
      [ "c" ]
    ];
    attrNamesToTrue.trivial = {
      a = true;
      b = false;
      c = true;
    };
    check =
      assert
        config.attrNamesToTrue.justNames == {
          a = true;
          b = true;
          c = true;
        };
      assert
        config.attrNamesToTrue.mixed == {
          a = true;
          b = false;
          c = true;
        };
      assert
        config.attrNamesToTrue.trivial == {
          a = true;
          b = false;
          c = true;
        };
      "ok";
  };
}
