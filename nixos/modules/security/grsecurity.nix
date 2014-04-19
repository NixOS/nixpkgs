{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.security.grsecurity;

  mkKernel = kernel: patch:
    assert patch.kversion == kernel.version;
      { inherit kernel patch;
        inherit (patch) grversion revision;
      };

  stable-patch = with pkgs.kernelPatches;
    if cfg.vserver then grsecurity_vserver else grsecurity_stable;
  stableKernel = mkKernel pkgs.linux_3_2  stable-patch;
  testKernel   = mkKernel pkgs.linux_3_13 pkgs.kernelPatches.grsecurity_unstable;

  ## -- grsecurity configuration -----------------------------------------------

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
    if cfg.config.virtualisationConfig == "none" then
      "GRKERNSEC_CONFIG_VIRT_NONE y"
    else if cfg.config.virtualisationConfig == "host" then
      "GRKERNSEC_CONFIG_VIRT_HOST y"
    else
      "GRKERNSEC_CONFIG_VIRT_GUEST y";

  grsecHwvirtCfg = if cfg.config.virtualisationConfig == "none" then "" else
    if cfg.config.hardwareVirtualisation == true then
      "GRKERNSEC_CONFIG_VIRT_EPT y"
    else
      "GRKERNSEC_CONFIG_VIRT_SOFT y";

  grsecVirtswCfg =
    let virtCfg = opt: "GRKERNSEC_CONFIG_VIRT_"+opt+" y";
    in
      if cfg.config.virtualisationConfig == "none" then ""
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
        randstruct = optionalString config.services.virtualbox.enable
          "GRKERNSEC_RANDSTRUCT n";
        # Disable restricting links under the testing kernel, as something
        # has changed causing it to fail miserably during boot.
        restrictLinks = optionalString cfg.testing
          "GRKERNSEC_LINK n";
    in ''
      SECURITY_APPARMOR y
      DEFAULT_SECURITY_APPARMOR y
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
      GRKERNSEC_NO_RBAC ${boolToKernOpt cfg.config.disableRBAC}
      ${randstruct}
      ${restrictLinks}

      ${cfg.config.kernelExtraConfig}
    '';

  ## -- grsecurity kernel packages ---------------------------------------------

  localver = grkern:
    "-grsec" + optionalString cfg.config.verboseVersion
       "-${grkern.grversion}-${grkern.revision}";

  grsecurityOverrider = args: grkern: {
    # Apparently as of gcc 4.6, gcc-plugin headers (which are needed by PaX plugins)
    # include libgmp headers, so we need these extra tweaks
    buildInputs = args.buildInputs ++ [ pkgs.gmp ];
    preConfigure = ''
      ${args.preConfigure or ""}
      sed -i 's|-I|-I${pkgs.gmp}/include -I|' scripts/gcc-plugin.sh
      sed -i 's|HOST_EXTRACFLAGS +=|HOST_EXTRACFLAGS += -I${pkgs.gmp}/include|' tools/gcc/Makefile
      sed -i 's|HOST_EXTRACXXFLAGS +=|HOST_EXTRACXXFLAGS += -I${pkgs.gmp}/include|' tools/gcc/Makefile
      rm localversion-grsec
      echo ${localver grkern} > localversion-grsec
    '';
  };

  mkGrsecPkg = grkern:
    let kernelPkg = lowPrio (overrideDerivation (grkern.kernel.override (args: {
          kernelPatches = args.kernelPatches ++ [ grkern.patch pkgs.kernelPatches.grsec_fix_path ];
          argsOverride = {
            modDirVersion = "${grkern.kernel.modDirVersion}${localver grkern}";
          };
          extraConfig = grsecConfig;
        })) (args: grsecurityOverrider args grkern));
    in pkgs.linuxPackagesFor kernelPkg (mkGrsecPkg grkern);

  grsecPackage = mkGrsecPkg (if cfg.stable then stableKernel else testKernel);
in
{
  options = {
    security.grsecurity = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable grsecurity support. This enables advanced exploit
          hardening for the Linux kernel, and adds support for
          administrative Role-Based Acess Control (RBAC) via
          <literal>gradm</literal>. It also includes traditional
          utilities for PaX.
        '';
      };

      stable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable the stable grsecurity patch, based on Linux 3.2.
        '';
      };

      vserver = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable the stable grsecurity/vserver patches, based on Linux 3.2.
        '';
      };

      testing = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable the testing grsecurity patch, based on Linux 3.13.
        '';
      };

      config = {
        mode = mkOption {
          type = types.str;
          default = "auto";
          example = "custom";
          description = ''
            grsecurity configuration mode. This specifies whether
            grsecurity is auto-configured or otherwise completely
            manually configured. Can either by
            <literal>custom</literal> or <literal>auto</literal>.

            <literal>auto</literal> is recommended.
          '';
        };

        priority = mkOption {
          type = types.str;
          default = "security";
          example = "performance";
          description = ''
            grsecurity configuration priority. This specifies whether
            the kernel configuration should emphasize speed or
            security. Can either by <literal>security</literal> or
            <literal>performance</literal>.
          '';
        };

        system = mkOption {
          type = types.str;
          default = "";
          example = "desktop";
          description = ''
            grsecurity system configuration. This specifies whether
            the kernel configuration should be suitable for a Desktop
            or a Server. Can either by <literal>server</literal> or
            <literal>desktop</literal>.
          '';
        };

        virtualisationConfig = mkOption {
          type = types.str;
          default = "none";
          example = "host";
          description = ''
            grsecurity virtualisation configuration. This specifies
            the virtualisation role of the machine - that is, whether
            it will be a virtual machine guest, a virtual machine
            host, or neither. Can be one of <literal>none</literal>,
            <literal>host</literal>, or <literal>guest</literal>.
          '';
        };

        hardwareVirtualisation = mkOption {
          type = types.nullOr types.bool;
          default = null;
          example = true;
          description = ''
            grsecurity hardware virtualisation configuration. Set to
            <literal>true</literal> if your machine supports hardware
            accelerated virtualisation.
          '';
        };

        virtualisationSoftware = mkOption {
          type = types.str;
          default = "";
          example = "kvm";
          description = ''
            grsecurity virtualisation software. Set this to the
            specified virtual machine technology if the machine is
            running as a guest, or a host.

            Can be one of <literal>kvm</literal>,
            <literal>xen</literal>, <literal>vmware</literal> or
            <literal>virtualbox</literal>.
          '';
        };

        sysctl = mkOption {
          type = types.bool;
          default = false;
          description = ''
            If true, then set <literal>GRKERN_SYSCTL y</literal>. If
            enabled then grsecurity can be controlled using sysctl
            (and turned off). You are advised to *never* enable this,
            but if you do, make sure to always set the sysctl
            <literal>kernel.grsecurity.grsec_lock</literal> to
            non-zero as soon as all sysctl options are set. *THIS IS
            EXTREMELY IMPORTANT*!

            If disabled, this also turns off the
            <literal>systemd-sysctl</literal> service.
          '';
        };

        denyChrootChmod = mkOption {
          type = types.bool;
          default = false;
          description = ''
            If true, then set <literal>GRKERN_CHROOT_CHMOD
            y</literal>. If enabled, this denies processes inside a
            chroot from setting the suid or sgid bits using
            <literal>chmod</literal> or <literal>fchmod</literal>.

            By default this protection is disabled - it makes it
            impossible to use Nix to build software on your system,
            which is what most users want.

            If you are using NixOps to deploy your software to a
            remote machine, you're encouraged to enable this as you
            won't need to compile code.
          '';
        };

        restrictProc = mkOption {
          type = types.bool;
          default = false;
          description = ''
            If true, then set <literal>GRKERN_PROC_USER
            y</literal>. This restricts non-root users to only viewing
            their own processes and restricts network-related
            information, kernel symbols, and module information.
          '';
        };

        restrictProcWithGroup = mkOption {
          type = types.bool;
          default = true;
          description = ''
            If true, then set <literal>GRKERN_PROC_USERGROUP
            y</literal>. This is similar to
            <literal>restrictProc</literal> except it allows a special
            group (specified by <literal>unrestrictProcGid</literal>)
            to still access otherwise classified information in
            <literal>/proc</literal>.
          '';
        };

        unrestrictProcGid = mkOption {
          type = types.int;
          default = config.ids.gids.grsecurity;
          description = ''
            If set, specifies a GID which is exempt from
            <literal>/proc</literal> restrictions (set by
            <literal>GRKERN_PROC_USERGROUP</literal>). By default,
            this is set to the GID for <literal>grsecurity</literal>,
            a predefined NixOS group, which the
            <literal>root</literal> account is a member of. You may
            conveniently add other users to this group if you need
            access to <literal>/proc</literal>
          '';
        };

        disableRBAC = mkOption {
          type = types.bool;
          default = false;
          description = ''
            If true, then set <literal>GRKERN_NO_RBAC
            y</literal>. This disables the
            <literal>/dev/grsec</literal> device, which in turn
            disables the RBAC system (and <literal>gradm</literal>).
          '';
        };

        verboseVersion = mkOption {
          type = types.bool;
          default = false;
          description = "Use verbose version in kernel localversion.";
        };

        kernelExtraConfig = mkOption {
          type = types.str;
          default = "";
          description = "Extra kernel configuration parameters.";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    assertions =
      [ { assertion = cfg.stable || cfg.testing;
          message   = ''
            If grsecurity is enabled, you must select either the
            stable patch (with kernel 3.2), or the testing patch (with
            kernel 3.13) to continue.
          '';
        }
        { assertion = (cfg.stable -> !cfg.testing) || (cfg.testing -> !cfg.stable);
          message   = ''
            You must select either the stable or testing patch, not
            both.
          '';
        }
        { assertion = (cfg.testing -> !cfg.vserver);
          message   = "The vserver patches are only supported in the stable kernel.";
        }
        { assertion = (cfg.config.restrictProc -> !cfg.config.restrictProcWithGroup) ||
                      (cfg.config.restrictProcWithGroup -> !cfg.config.restrictProc);
          message   = "You cannot enable both restrictProc and restrictProcWithGroup";
        }
        { assertion = config.boot.kernelPackages.kernel.features ? grsecurity
                   && config.boot.kernelPackages.kernel.features.grsecurity;
          message = "grsecurity enabled, but kernel doesn't have grsec support";
        }
        { assertion = elem cfg.config.mode [ "auto" "custom" ];
          message = "grsecurity mode must either be 'auto' or 'custom'.";
        }
        { assertion = cfg.config.mode == "auto" -> elem cfg.config.system [ "desktop" "server" ];
          message = "when using auto grsec mode, system must be either 'desktop' or 'server'";
        }
        { assertion = cfg.config.mode == "auto" -> elem cfg.config.priority [ "performance" "security" ];
          message = "when using auto grsec mode, priority must be 'performance' or 'security'.";
        }
        { assertion = cfg.config.mode == "auto" -> elem cfg.config.virtualisationConfig [ "host" "guest" "none" ];
          message = "when using auto grsec mode, 'virt' must be 'host', 'guest' or 'none'.";
        }
        { assertion = (cfg.config.mode == "auto" && (elem cfg.config.virtualisationConfig [ "host" "guest" ])) ->
              cfg.config.hardwareVirtualisation != null;
          message   = "when using auto grsec mode with virtualisation, you must specify if your hardware has virtualisation extensions";
        }
        { assertion = (cfg.config.mode == "auto" && (elem cfg.config.virtualisationConfig [ "host" "guest" ])) ->
              elem cfg.config.virtualisationSoftware [ "kvm" "xen" "virtualbox" "vmware" ];
          message   = "virtualisation software must be 'kvm', 'xen', 'vmware' or 'virtualbox'";
        }
      ];

    systemd.services.grsec-lock = mkIf cfg.config.sysctl {
      description     = "grsecurity sysctl-lock Service";
      requires        = [ "sysctl.service" ];
      wantedBy        = [ "multi-user.target" ];
      serviceConfig.Type = "oneshot";
      serviceConfig.RemainAfterExit = "yes";
      script = ''
        locked=`cat /proc/sys/kernel/grsecurity/grsec_lock`
        if [ "$locked" == "0" ]; then
            echo 1 > /proc/sys/kernel/grsecurity/grsec_lock
            echo grsecurity sysctl lock - enabled
        else
            echo grsecurity sysctl lock already enabled - doing nothing
        fi
      '';
    };

#   systemd.services.grsec-learn = {
#     description     = "grsecurity learning Service";
#     wantedBy        = [ "local-fs.target" ];
#     serviceConfig   = {
#       Type = "oneshot";
#       RemainAfterExit = "yes";
#       ExecStart = "${pkgs.gradm}/sbin/gradm -VFL /etc/grsec/learning.logs";
#       ExecStop  = "${pkgs.gradm}/sbin/gradm -D";
#     };
#   };

    system.activationScripts.grsec =
      ''
        mkdir -p /etc/grsec
        if [ ! -f /etc/grsec/learn_config ]; then
          cp ${pkgs.gradm}/etc/grsec/learn_config /etc/grsec
        fi
        if [ ! -f /etc/grsec/policy ]; then
          cp ${pkgs.gradm}/etc/grsec/policy /etc/grsec
        fi
        chmod -R 0600 /etc/grsec
      '';

    # Enable apparmor support, gradm udev rules, and utilities
    security.apparmor.enable   = true;
    boot.kernelPackages        = grsecPackage;
    services.udev.packages     = [ pkgs.gradm ];
    environment.systemPackages = [ pkgs.gradm pkgs.paxctl pkgs.pax-utils ];
  };
}
