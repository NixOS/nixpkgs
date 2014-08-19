{ config, pkgs, lib, ... }:

let
  configfile = builtins.storePath (builtins.toFile "config" (lib.concatStringsSep "\n"
    (map (builtins.getAttr "configLine") config.system.requiredKernelConfig))
  );

  origKernel = pkgs.buildLinux {
    inherit (pkgs.linux) src version;
    inherit configfile;
    allowImportFromDerivation = true;
    kernelPatches = [ pkgs.kernelPatches.cifs_timeout_2_6_38 ];
  };

  kernel = origKernel // (derivation (origKernel.drvAttrs // {
    configurePhase = ''
      runHook preConfigure
      mkdir ../build
      make $makeFlags "''${makeFlagsArray[@]}" mrproper
      make $makeFlags "''${makeFlagsArray[@]}" KCONFIG_ALLCONFIG=${configfile} allnoconfig
      runHook postConfigure
    '';
  }));

   kernelPackages = pkgs.linuxPackagesFor kernel;
in {
  boot.kernelPackages = kernelPackages;
}
