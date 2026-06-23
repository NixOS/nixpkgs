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
  imports = [
    {
      options = {
        pathInStore = mkOption { type = types.lazyAttrsOf (types.pathWith { inStore = true; }); };
        pathNotInStore = mkOption { type = types.lazyAttrsOf (types.pathWith { inStore = false; }); };
        anyPath = mkOption { type = types.lazyAttrsOf (types.pathWith { }); };
        absolutePathNotInStore = mkOption {
          type = types.lazyAttrsOf (
            types.pathWith {
              inStore = false;
              absolute = true;
            }
          );
        };

        # This conflicts with `conflictingPathOptionType` below.
        conflictingPathOptionType = mkOption { type = types.pathWith { absolute = true; }; };

        # This doesn't make sense: the only way to have something be `inStore`
        # is to have an absolute path.
        impossiblePathOptionType = mkOption {
          type = types.pathWith {
            inStore = true;
            absolute = false;
          };
        };
      };
    }
    {
      options = {
        # This should merge cleanly with `pathNotInStore` above.
        pathNotInStore = mkOption {
          type = types.lazyAttrsOf (
            types.pathWith {
              inStore = false;
              absolute = null;
            }
          );
        };

        # This conflicts with `conflictingPathOptionType` above.
        conflictingPathOptionType = mkOption { type = types.pathWith { absolute = false; }; };
      };
    }
  ];

  pathInStore.ok1 = "${storeDir}/0lz9p8xhf89kb1c1kk6jxrzskaiygnlh-bash-5.2-p15.drv";
  pathInStore.ok2 = "${storeDir}/0fb3ykw9r5hpayd05sr0cizwadzq1d8q-bash-5.2-p15";
  pathInStore.ok3 = "${storeDir}/0fb3ykw9r5hpayd05sr0cizwadzq1d8q-bash-5.2-p15/bin/bash";
  pathInStore.ok4 = "/1121rp0gvr1qya7hvy925g5kjwg66acz6sn1ra1hca09f1z5dsab"; # CA derivation
  pathInStore.ok5 = "/1121rp0gvr1qya7hvy925g5kjwg66acz6sn1ra1hca09f1z5dsab/bin/bash"; # CA derivation
  pathInStore.ok6 = /1121rp0gvr1qya7hvy925g5kjwg66acz6sn1ra1hca09f1z5dsab; # CA derivation, path type
  pathInStore.bad1 = "";
  pathInStore.bad2 = "${storeDir}";
  pathInStore.bad3 = "${storeDir}/";
  pathInStore.bad4 = "${storeDir}/.links"; # technically true, but not reasonable
  pathInStore.bad5 = "/foo/bar";

  pathNotInStore.ok1 = "/foo/bar";
  pathNotInStore.ok2 = "${storeDir}"; # strange, but consistent with `pathInStore` above
  pathNotInStore.ok3 = "${storeDir}/"; # also strange, but also consistent
  pathNotInStore.ok4 = "";
  pathNotInStore.ok5 = "${storeDir}/.links"; # strange, but consistent with `pathInStore` above
  pathNotInStore.bad1 = "${storeDir}/0lz9p8xhf89kb1c1kk6jxrzskaiygnlh-bash-5.2-p15.drv";
  pathNotInStore.bad2 = "${storeDir}/0fb3ykw9r5hpayd05sr0cizwadzq1d8q-bash-5.2-p15";
  pathNotInStore.bad3 = "${storeDir}/0fb3ykw9r5hpayd05sr0cizwadzq1d8q-bash-5.2-p15/bin/bash";
  pathNotInStore.bad4 = ./pathWith.nix;

  anyPath.ok1 = "/this/is/absolute";
  anyPath.ok2 = "./this/is/relative";
  anyPath.bad1 = 42;

  absolutePathNotInStore.ok1 = "/this/is/absolute";
  absolutePathNotInStore.bad1 = "./this/is/relative";
  absolutePathNotInStore.bad2 = "${storeDir}/0fb3ykw9r5hpayd05sr0cizwadzq1d8q-bash-5.2-p15";

  conflictingPathOptionType = "/foo/bar";

  impossiblePathOptionType = "/foo/bar";
}
