{ lib, ... }:
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
    pathInStore = mkOption { type = types.lazyAttrsOf types.pathInStore; };
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
  };
}
