{ callPackage, lib, makeSetupHook, srcOnly, nodejs }:
{
  npmConfigHook = makeSetupHook
    {
      name = "npm-config-hook";
      substitutions = {
        nodeSrc = srcOnly nodejs;
        nodeGyp = "${nodejs}/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js";
        canonicalizeSymlinksScript = ./canonicalize-symlinks.js;
        storePrefix = builtins.storeDir;
      };
    } ./npm-config-hook.sh;
}
