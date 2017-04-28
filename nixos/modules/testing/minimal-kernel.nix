{ config, pkgs, lib, ... }:

with builtins;

let
  configfile = storePath (toFile "config" ((lib.concatStringsSep "\n"
    (lib.unique (catAttrs "configLine" config.system.requiredKernelConfig))
  ) + "\n"));

  origKernel = pkgs.buildLinux {
    inherit (pkgs.linux) src version;
    inherit configfile;
    allowImportFromDerivation = true;
  };

  kernelOverrides = origAttrs: origKernel.drvAttrs // {
    configurePhase = ''
      runHook preConfigure
      mkdir -p ../build
      make $makeFlags "''${makeFlagsArray[@]}" mrproper
      make $makeFlags "''${makeFlagsArray[@]}" KCONFIG_ALLCONFIG=${configfile} allnoconfig
      runHook postConfigure
    '';
  };

   kernelPackages = pkgs.linuxPackagesFor origKernel;
in {
  boot.kernelOverrides = kernelOverrides;
  boot.kernelPackages = kernelPackages;
}
