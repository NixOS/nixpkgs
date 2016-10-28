{ config, pkgs, lib, ... }:

with builtins;

let
  configfile = toFile "config" ((lib.concatStringsSep "\n"
    (lib.unique (catAttrs "configLine" config.system.requiredKernelConfig))
  ) + "\n");

  kernel = lib.makeOverridable (kernel: lib.overrideDerivation kernel (origAttrs: {
    allowImportFromDerivation = true;

    configurePhase = ''
      runHook preConfigure
      mkdir -p ../build
      make $makeFlags "''${makeFlagsArray[@]}" mrproper
      make $makeFlags "''${makeFlagsArray[@]}" KCONFIG_ALLCONFIG=${configfile} allnoconfig
      runHook postConfigure
    '';
  })) pkgs.linuxPackages.kernel;

  kernelPackages = pkgs.linuxPackagesFor kernel;
in {
  boot.kernelPackages = kernelPackages;
}
