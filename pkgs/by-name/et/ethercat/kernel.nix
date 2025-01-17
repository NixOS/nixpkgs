{
  callPackage,
  autoreconfHook,
  pkg-config,
  stdenv,
  lib,
  kernel,
  ethercat,
}:
let
  common = callPackage ./common.nix { };

  # From: https://docs.etherlab.org/ethercat/1.6/doxygen/devicedrivers.html
  deviceKernelCompatabilities = {
    "6.6" = [ "igc" ];
    "6.4" = [
      "e100"
      "igc"
    ];
    "6.1" = [
      "8139too"
      "bcmgenet"
      "e100"
      # "e1000" # Is broken
      "e1000e"
      "igb"
      # "igc" # Is broken
      "r8169"
    ];
    "5.15" = [
      "8139too"
      "e100"
      "e1000"
      "e1000e"
      "igb"
      "r8169"
    ];
    "5.14" = [
      "8139too"
      "bcmgenet"
      "e100"
      "e1000"
      "e1000e"
      "igb"
      "igc"
      "r8169"
    ];
    "5.10" = [
      "8139too"
      "bcmgenet"
      "e100"
      "e1000"
      "e1000e"
      "igb"
      "r8169"
    ];
    "5.4" = [
      "e100"
      "e1000e"
    ];
    "4.19" = [ "igb" ];
    "4.4" = [
      "8139too"
      "e100"
      "e1000"
      "e1000e"
      "igb"
      "r8169"
    ];
    "3.18" = [ "igb" ];
    "3.16" = [
      "8139too"
      "e100"
      "e1000"
      "e1000e"
      "r8169"
    ];
    "3.14" = [
      "8139too"
      "e100"
      "e1000"
      "e1000e"
      "r8169"
    ];
    "3.12" = [
      "8139too"
      "e100"
      "e1000"
      "e1000e"
      "r8169"
    ];
    "3.10" = [
      "8139too"
      "e100"
      "e1000"
      "e1000e"
      "r8169"
    ];
    "3.8" = [
      "8139too"
      "e100"
      "e1000"
      "e1000e"
      "r8169"
    ];
    "3.6" = [
      "8139too"
      "e100"
      "e1000"
      "e1000e"
      "r8169"
    ];
    "3.4" = [
      "8139too"
      "e100"
      "e1000"
      "e1000e"
      "r8169"
    ];
    "3.2" = [
      "8139too"
      "e1000e"
      "r8169"
    ];
    "3.0" = [
      "8139too"
      "e100"
      "e1000"
    ];
  };

  kernelVersionMajorMinor =
    with builtins;
    concatStringsSep "." (lib.lists.take 2 (splitVersion kernel.version));

  supportedDrivers = deviceKernelCompatabilities.${kernelVersionMajorMinor} or [ ];
in
common.overrideAttrs (
  finalAttrs: previousAttrs: ({
    pname = "${previousAttrs.pname}-kernel";

    hardeningDisable = [
      "pic"
      "format"
    ];

    outputs = [
      "bin"
      "out"
    ];

    buildInputs = [ kernel.moduleBuildDependencies ];

    makeFlags = [
      "KERNELRELEASE=${kernel.modDirVersion}"
      "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
      "INSTALL_MOD_PATH=$(bin)"
    ];

    configureFlags =
      previousAttrs.configureFlags
      ++ [
        "--enable-tool=no"
        "--enable-userlib=no"
        "--enable-kernel=yes"
        "--with-linux-dir=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
      ]
      ++ builtins.map (driver: "--enable-${driver}=yes") supportedDrivers;

    buildFlags = [ "modules" ];
    installTargets = [ "modules_install" ];
  })
)
