{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.security.grsecurity;

  customGrsecPkg =
    (import ../../../pkgs/build-support/grsecurity {
      grsecOptions = cfg;
      inherit pkgs lib;
    }).grsecPackage;
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

      kernelPatch = mkOption {
        type = types.attrs;
        example = lib.literalExample "pkgs.kernelPatches.grsecurity_4_1";
        description = ''
          Grsecurity patch to use.
        '';
      };

      config = {
        mode = mkOption {
          type = types.enum [ "auto" "custom" ];
          default = "auto";
          description = ''
            grsecurity configuration mode. This specifies whether
            grsecurity is auto-configured or otherwise completely
            manually configured.
          '';
        };

        priority = mkOption {
          type = types.enum [ "security" "performance" ];
          default = "security";
          description = ''
            grsecurity configuration priority. This specifies whether
            the kernel configuration should emphasize speed or
            security.
          '';
        };

        system = mkOption {
          type = types.enum [ "desktop" "server" ];
          default = "desktop";
          description = ''
            grsecurity system configuration.
          '';
        };

        virtualisationConfig = mkOption {
          type = types.nullOr (types.enum [ "host" "guest" ]);
          default = null;
          description = ''
            grsecurity virtualisation configuration. This specifies
            the virtualisation role of the machine - that is, whether
            it will be a virtual machine guest, a virtual machine
            host, or neither.
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
          type = types.nullOr (types.enum [ "kvm" "xen" "vmware" "virtualbox" ]);
          default = null;
          description = ''
            Configure grsecurity for use with this virtualisation software.
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

        denyChrootCaps = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Whether to lower capabilities of all processes within a chroot,
            preventing commands that require <literal>CAP_SYS_ADMIN</literal>.

            This protection is disabled by default because it breaks
            <literal>nixos-rebuild</literal>. Whenever possible, it is
            highly recommended to enable this protection.
          '';
        };

        denyUSB = mkOption {
          type = types.bool;
          default = false;
          description = ''
            If true, then set <literal>GRKERNSEC_DENYUSB y</literal>.

            This enables a sysctl with name
            <literal>kernel.grsecurity.deny_new_usb</literal>. Setting
            its value to <literal>1</literal> will prevent any new USB
            devices from being recognized by the OS.  Any attempted
            USB device insertion will be logged.

            This option is intended to be used against custom USB
            devices designed to exploit vulnerabilities in various USB
            device drivers.
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

        disableSimultConnect = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Disable TCP simultaneous connect.  The TCP simultaneous connect
            feature allows two clients to connect without either of them
            entering the listening state.  This feature of the TCP specification
            is claimed to enable an attacker to deny the target access to a given
            server by guessing the source port the target would use to make the
            connection.

            This option is OFF by default because TCP simultaneous connect has
            some legitimate uses.  Enable this option if you know what this TCP
            feature is for and know that you do not need it.
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
      [
        { assertion = (cfg.config.restrictProc -> !cfg.config.restrictProcWithGroup) ||
                      (cfg.config.restrictProcWithGroup -> !cfg.config.restrictProc);
          message   = "You cannot enable both restrictProc and restrictProcWithGroup";
        }
        { assertion = config.boot.kernelPackages.kernel.features ? grsecurity
                   && config.boot.kernelPackages.kernel.features.grsecurity;
          message = "grsecurity enabled, but kernel doesn't have grsec support";
        }
        { assertion = (cfg.config.mode == "auto" && (cfg.config.virtualisationConfig != null)) ->
              cfg.config.hardwareVirtualisation != null;
          message   = "when using auto grsec mode with virtualisation, you must specify if your hardware has virtualisation extensions";
        }
        { assertion = (cfg.config.mode == "auto" && (cfg.config.virtualisationConfig != null)) ->
              cfg.config.virtualisationSoftware != null;
         message   = "grsecurity configured for virtualisation but no virtualisation software specified";
        }
      ];

    security.grsecurity.kernelPatch = lib.mkDefault pkgs.kernelPatches.grsecurity_latest;

    systemd.services.grsec-lock = mkIf cfg.config.sysctl {
      description     = "grsecurity sysctl-lock Service";
      wants           = [ "systemd-sysctl.service" ];
      after           = [ "systemd-sysctl.service" ];
      wantedBy        = [ "multi-user.target" ];
      serviceConfig.Type = "oneshot";
      serviceConfig.RemainAfterExit = "yes";
      unitConfig.ConditionPathIsReadWrite = "/proc/sys/kernel/grsecurity/grsec_lock";
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

    system.activationScripts = lib.optionalAttrs (!cfg.config.disableRBAC) { grsec = ''
      mkdir -p /etc/grsec
      if [ ! -f /etc/grsec/learn_config ]; then
        cp ${pkgs.gradm}/etc/grsec/learn_config /etc/grsec
      fi
      if [ ! -f /etc/grsec/policy ]; then
        cp ${pkgs.gradm}/etc/grsec/policy /etc/grsec
      fi
      chmod -R 0600 /etc/grsec
    ''; };

    # Enable AppArmor, gradm udev rules, and utilities
    security.apparmor.enable   = true;
    boot.kernelPackages        = customGrsecPkg;
    services.udev.packages     = lib.optional (!cfg.config.disableRBAC) pkgs.gradm;
    environment.systemPackages = [ pkgs.paxctl pkgs.pax-utils ] ++ lib.optional (!cfg.config.disableRBAC) pkgs.gradm;
  };
}
