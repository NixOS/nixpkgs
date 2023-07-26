{ config, lib, pkgs, ... }: with lib;
let
  cfg = config.boot.iscsi-initiator;
in
{
  # If you're booting entirely off another machine you may want to add
  # this snippet to always boot the latest "system" version. It is not
  # enabled by default in case you have an initrd on a local disk:
  #
  #     boot.initrd.postMountCommands = ''
  #       ln -sfn /nix/var/nix/profiles/system/init /mnt-root/init
  #       stage2Init=/init
  #     '';
  #
  # Note: Theoretically you might want to connect to multiple portals and
  # log in to multiple targets, however the authors of this module so far
  # don't have the need or expertise to reasonably implement it. Also,
  # consider carefully before making your boot chain depend on multiple
  # machines to be up.
  options.boot.iscsi-initiator = with types; {
    name = mkOption {
      description = lib.mdDoc ''
        Name of the iSCSI initiator to boot from. Note, booting from iscsi
        requires networkd based networking.
      '';
      default = null;
      example = "iqn.2020-08.org.linux-iscsi.initiatorhost:example";
      type = nullOr str;
    };

    discoverPortal = mkOption {
      description = lib.mdDoc ''
        iSCSI portal to boot from.
      '';
      default = null;
      example = "192.168.1.1:3260";
      type = nullOr str;
    };

    target = mkOption {
      description = lib.mdDoc ''
        Name of the iSCSI target to boot from.
      '';
      default = null;
      example = "iqn.2020-08.org.linux-iscsi.targethost:example";
      type = nullOr str;
    };

    logLevel = mkOption {
      description = lib.mdDoc ''
        Higher numbers elicits more logs.
      '';
      default = 1;
      example = 8;
      type = int;
    };

    loginAll = mkOption {
      description = lib.mdDoc ''
        Do not log into a specific target on the portal, but to all that we discover.
        This overrides setting target.
      '';
      type = bool;
      default = false;
    };

    extraIscsiCommands = mkOption {
      description = lib.mdDoc "Extra iscsi commands to run in the initrd.";
      default = "";
      type = lines;
    };

    extraConfig = mkOption {
      description = lib.mdDoc "Extra lines to append to /etc/iscsid.conf";
      default = null;
      type = nullOr lines;
    };

    extraConfigFile = mkOption {
      description = lib.mdDoc ''
        Append an additional file's contents to `/etc/iscsid.conf`. Use a non-store path
        and store passwords in this file. Note: the file specified here must be available
        in the initrd, see: `boot.initrd.secrets`.
      '';
      default = null;
      type = nullOr str;
    };
  };

  config = mkIf (cfg.name != null) {
    # The "scripted" networking configuration (ie: non-networkd)
    # doesn't properly order the start and stop of the interfaces, and the
    # network interfaces are torn down before unmounting disks. Since this
    # module is specifically for very-early-boot network mounts, we need
    # the network to stay on.
    #
    # We could probably fix the scripted options to properly order, but I'm
    # not inclined to invest that time today. Hopefully this gets users far
    # enough along and they can just use networkd.
    networking.useNetworkd = true;
    networking.useDHCP = false; # Required to set useNetworkd = true

    boot.initrd = {
      network.enable = true;

      # By default, the stage-1 disables the network and resets the interfaces
      # on startup. Since our startup disks are on the network, we can't let
      # the network not work.
      network.flushBeforeStage2 = false;

      kernelModules = [ "iscsi_tcp" ];

      extraUtilsCommands = ''
        copy_bin_and_libs ${pkgs.openiscsi}/bin/iscsid
        copy_bin_and_libs ${pkgs.openiscsi}/bin/iscsiadm
        ${optionalString (!config.boot.initrd.network.ssh.enable) "cp -pv ${pkgs.glibc.out}/lib/libnss_files.so.* $out/lib"}

        mkdir -p $out/etc/iscsi
        cp ${config.environment.etc.hosts.source} $out/etc/hosts
        cp ${pkgs.openiscsi}/etc/iscsi/iscsid.conf $out/etc/iscsi/iscsid.fragment.conf
        chmod +w $out/etc/iscsi/iscsid.fragment.conf
        cat << 'EOF' >> $out/etc/iscsi/iscsid.fragment.conf
        ${optionalString (cfg.extraConfig != null) cfg.extraConfig}
        EOF
      '';

      extraUtilsCommandsTest = ''
        $out/bin/iscsiadm --version
      '';

      preLVMCommands = let
        extraCfgDumper = optionalString (cfg.extraConfigFile != null) ''
          if [ -f "${cfg.extraConfigFile}" ]; then
            printf "\n# The following is from ${cfg.extraConfigFile}:\n"
            cat "${cfg.extraConfigFile}"
          else
            echo "Warning: boot.iscsi-initiator.extraConfigFile ${cfg.extraConfigFile} does not exist!" >&2
          fi
        '';
      in ''
        ${optionalString (!config.boot.initrd.network.ssh.enable) ''
        # stolen from initrd-ssh.nix
        echo 'root:x:0:0:root:/root:/bin/ash' > /etc/passwd
        echo 'passwd: files' > /etc/nsswitch.conf
      ''}

        cp -f $extraUtils/etc/hosts /etc/hosts

        mkdir -p /etc/iscsi /run/lock/iscsi
        echo "InitiatorName=${cfg.name}" > /etc/iscsi/initiatorname.iscsi

        (
          cat "$extraUtils/etc/iscsi/iscsid.fragment.conf"
          printf "\n"
          ${optionalString cfg.loginAll ''echo "node.startup = automatic"''}
          ${extraCfgDumper}
        ) > /etc/iscsi/iscsid.conf

        iscsid --foreground --no-pid-file --debug ${toString cfg.logLevel} &
        iscsiadm --mode discoverydb \
          --type sendtargets \
          --discover \
          --portal ${escapeShellArg cfg.discoverPortal} \
          --debug ${toString cfg.logLevel}

        ${if cfg.loginAll then ''
        iscsiadm --mode node --loginall all
      '' else ''
        iscsiadm --mode node --targetname ${escapeShellArg cfg.target} --login
      ''}

        ${cfg.extraIscsiCommands}

        pkill -9 iscsid
      '';
    };

    services.openiscsi = {
      enable = true;
      inherit (cfg) name;
    };

    assertions = [
      {
        assertion = cfg.loginAll -> cfg.target == null;
        message = "iSCSI target name is set while login on all portals is enabled.";
      }
      {
        assertion = !config.boot.initrd.systemd.enable;
        message = "systemd stage 1 does not support iscsi yet.";
      }
    ];
  };
}
