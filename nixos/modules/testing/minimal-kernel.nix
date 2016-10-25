{ config, pkgs, lib, ... }:

with builtins;

let
  removeAttrs = e: k: filter (x: x."${k}" != e."${k}");

  uniqueAttrs = list: key:
    if list == [] then []
    else
      let
        x = head list;
        xs = uniqueAttrs (lib.drop 1 list) key;
      in [x] ++ removeAttrs x key xs;

  uniqueReqKernConfig = uniqueAttrs config.system.requiredKernelConfig "configLine";

  configfile = storePath (toFile "config" (lib.concatStringsSep "\n"
    (map (getAttr "configLine") uniqueReqKernConfig))
  );

  origKernel = pkgs.buildLinux {
    inherit (pkgs.linux) src version;
    inherit configfile;
    allowImportFromDerivation = true;
  };

  kernelOverrides = origAttrs: derivation (origKernel.drvAttrs // {
    configurePhase = ''
      runHook preConfigure
      mkdir ../build
      make $makeFlags "''${makeFlagsArray[@]}" mrproper
      make $makeFlags "''${makeFlagsArray[@]}" KCONFIG_ALLCONFIG=${configfile} allnoconfig
      runHook postConfigure
    '';
  });

   kernelPackages = pkgs.linuxPackagesFor kernel;
in {
  boot.kernelOverrides = kernelOverrides;
  boot.kernelPackages = kernelPackages;
}
