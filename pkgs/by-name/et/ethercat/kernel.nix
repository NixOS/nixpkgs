{
  autoreconfHook,
  pkg-config,
  stdenv,
  pkgs,
  lib,
  kernel,
}:
let
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

  kernelVersionMajorMinor = builtins.concatStringsSep "." (
    lib.lists.take 2 (builtins.splitVersion kernel.version)
  );

  supportedDrivers = deviceKernelCompatabilities.${kernelVersionMajorMinor};
in
stdenv.mkDerivation (
  finalAttrs:
  (
    with pkgs.ethercat;
    {
      inherit version;
      inherit src;
      inherit meta;
    }
    // {
      pname = "ethercat-kernel";

      separateDebugInfo = true;
      hardeningDisable = [
        "pic"
        "format"
      ];

      nativeBuildInputs = [
        autoreconfHook
        pkg-config
        kernel.moduleBuildDependencies
      ];

      enableParallelBuilding = true;

      makeFlags = [
        "KERNELRELEASE=${kernel.modDirVersion}"
        "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
        "INSTALL_MOD_PATH=$(out)"
      ];

      configureFlags = [
        # Components
        "--enable-tool=no"
        "--enable-userlib=no"
        "--enable-kernel=yes"

        # Features
        "--enable-eoe=yes"
        "--enable-cycles=yes"
        "--enable-rtmutex=yes"
        "--enable-hrtimer=yes"
        "--enable-regalias=yes"
        "--enable-refclkop=yes"
        "--enable-tty=no" # Is broken
        "--enable-wildcards"

        # Devices
        "--enable-generic"
        "--enable-ccat"

        # Kernel
        "--with-linux-dir=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"

        # Debugging
        "--enable-debug-if=yes"
        "--enable-debug-ring=no" # Is broken
      ] ++ builtins.map (driver: "--enable-${driver}=yes") supportedDrivers;

      buildFlags = [ "modules" ];

      installTargets = [ "modules_install" ];
    }
  )
)
