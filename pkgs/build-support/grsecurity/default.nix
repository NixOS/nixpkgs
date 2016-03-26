{ grsecOptions, lib, pkgs }:

with lib;

let
  cfg = {
    stable  = grsecOptions.stable  or false;
    testing = grsecOptions.testing or false;
    config = {
      mode = "auto";
      sysctl = false;
      denyChrootChmod = false;
      denyUSB = false;
      restrictProc = false;
      restrictProcWithGroup = true;
      unrestrictProcGid = 121; # Ugh, an awful hack. See grsecurity NixOS gid
      disableRBAC = false;
      verboseVersion = false;
      kernelExtraConfig = "";
    } // grsecOptions.config;
  };

  vals = rec {

    mkKernel = kernel: patch:
      assert patch.kversion == kernel.version;
        { inherit kernel patch;
          inherit (patch) grversion revision;
        };

    test-patch = with pkgs.kernelPatches; grsecurity_unstable;
    stable-patch = with pkgs.kernelPatches; grsecurity_stable;

    grKernel = if cfg.stable
               then mkKernel pkgs.linux_3_14 stable-patch
               else mkKernel pkgs.linux_4_3 test-patch;

    ## -- grsecurity configuration ---------------------------------------------

    grsecPrioCfg =
      if cfg.config.priority == "security" then
        "GRKERNSEC_CONFIG_PRIORITY_SECURITY y"
      else
        "GRKERNSEC_CONFIG_PRIORITY_PERF y";

    grsecSystemCfg =
      if cfg.config.system == "desktop" then
        "GRKERNSEC_CONFIG_DESKTOP y"
      else
        "GRKERNSEC_CONFIG_SERVER y";

    grsecVirtCfg =
      if cfg.config.virtualisationConfig == null then
        "GRKERNSEC_CONFIG_VIRT_NONE y"
      else if cfg.config.virtualisationConfig == "host" then
        "GRKERNSEC_CONFIG_VIRT_HOST y"
      else
        "GRKERNSEC_CONFIG_VIRT_GUEST y";

    grsecHwvirtCfg = if cfg.config.virtualisationConfig == null then "" else
      if cfg.config.hardwareVirtualisation == true then
        "GRKERNSEC_CONFIG_VIRT_EPT y"
      else
        "GRKERNSEC_CONFIG_VIRT_SOFT y";

    grsecVirtswCfg =
      let virtCfg = opt: "GRKERNSEC_CONFIG_VIRT_"+opt+" y";
      in
        if cfg.config.virtualisationConfig == null then ""
        else if cfg.config.virtualisationSoftware == "xen"    then virtCfg "XEN"
        else if cfg.config.virtualisationSoftware == "kvm"    then virtCfg "KVM"
        else if cfg.config.virtualisationSoftware == "vmware" then virtCfg "VMWARE"
        else                                                       virtCfg "VIRTUALBOX";

    grsecMainConfig = if cfg.config.mode == "custom" then "" else ''
      GRKERNSEC_CONFIG_AUTO y
      ${grsecPrioCfg}
      ${grsecSystemCfg}
      ${grsecVirtCfg}
      ${grsecHwvirtCfg}
      ${grsecVirtswCfg}
    '';

    grsecConfig =
      let boolToKernOpt = b: if b then "y" else "n";
          # Disable RANDSTRUCT under virtualbox, as it has some kind of
          # breakage with the vbox guest drivers
          #randstruct = optionalString config.virtualisation.virtualbox.guest.enable
          #  "GRKERNSEC_RANDSTRUCT n";

          # Disable restricting links under the testing kernel, as something
          # has changed causing it to fail miserably during boot.
          restrictLinks = optionalString cfg.testing
            "GRKERNSEC_LINK n";
      in ''
        GRKERNSEC y
        ${grsecMainConfig}

        ${if cfg.config.restrictProc then
            "GRKERNSEC_PROC_USER y"
          else
            optionalString cfg.config.restrictProcWithGroup ''
              GRKERNSEC_PROC_USERGROUP y
              GRKERNSEC_PROC_GID ${toString cfg.config.unrestrictProcGid}
            ''
        }

        GRKERNSEC_SYSCTL ${boolToKernOpt cfg.config.sysctl}
        GRKERNSEC_CHROOT_CHMOD ${boolToKernOpt cfg.config.denyChrootChmod}
        GRKERNSEC_DENYUSB ${boolToKernOpt cfg.config.denyUSB}
        GRKERNSEC_NO_RBAC ${boolToKernOpt cfg.config.disableRBAC}
        ${restrictLinks}

        ${cfg.config.kernelExtraConfig}
      '';

    ## -- grsecurity kernel packages -------------------------------------------

    localver = grkern:
      "-grsec" + optionalString cfg.config.verboseVersion
         "-${grkern.grversion}-${grkern.revision}";

    grsecurityOverrider = args: grkern: {
      # Apparently as of gcc 4.6, gcc-plugin headers (which are needed by PaX plugins)
      # include libgmp headers, so we need these extra tweaks
      # As of gcc5 we also need libmpc
      buildInputs = args.buildInputs ++ [ pkgs.gmp pkgs.libmpc pkgs.mpfr ];
      preConfigure = ''
        extraIncludes="-I${pkgs.gmp}/include -I${pkgs.libmpc}/include -I${pkgs.mpfr}/include"
        ${args.preConfigure or ""}
        sed -i "s|-I|$extraIncludes -I|" scripts/gcc-plugin.sh
        sed -i "s|HOST_EXTRACFLAGS +=|HOST_EXTRACFLAGS += $extraIncludes|" tools/gcc/Makefile
        sed -i "s|HOST_EXTRACXXFLAGS +=|HOST_EXTRACXXFLAGS += $extraIncludes|" tools/gcc/Makefile
        rm localversion-grsec
        echo ${localver grkern} > localversion-grsec
      '';
    };

    mkGrsecKern = grkern:
      lowPrio (overrideDerivation (grkern.kernel.override (args: {
        kernelPatches = args.kernelPatches ++ [ grkern.patch pkgs.kernelPatches.grsec_fix_path ];
        argsOverride = {
          modDirVersion = "${grkern.kernel.modDirVersion}${localver grkern}";
        };
        extraConfig = grsecConfig;
        features.grsecurity = true;
        ignoreConfigErrors = true; # Too lazy to model the config options that work with grsecurity and don't for now
      })) (args: grsecurityOverrider args grkern));

    mkGrsecPkg = grkern: pkgs.linuxPackagesFor grkern (mkGrsecPkg grkern);

    ## -- Kernel packages ------------------------------------------------------

    grsecKernel  = mkGrsecKern grKernel;
    grsecPackage = mkGrsecPkg grsecKernel;
  };
in vals
