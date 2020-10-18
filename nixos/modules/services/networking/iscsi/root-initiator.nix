{ config, lib, pkgs, ... }: with lib;
let
  cfg = config.boot.iscsi-initiator;
in {
  # Note: Theoretically you might want to connect to multiple portals and log in to multiple targets
  # However, we assume that you're only crazy enough to boot from iSCSI but not actually crazy enough to boot from multiple iSCSI targets
  # If you are, feel free to implement it, it shouldn't be _that_ hard.
  options.boot.iscsi-initiator = with types; {
    name = mkOption {
      description = ''
        Name of the iSCSI initiator to boot from.
      '';
      default = null;
      example = "iqn.2020-08.org.linux-iscsi.initiatorhost:example";
      type = nullOr str;
    };

    discoverPortal = mkOption {
      description = ''
        iSCSI portal to boot from.
      '';
      default = null;
      example = "192.168.1.1:3260";
      type = nullOr str;
    };

    target = mkOption {
      description = ''
        Name of the iSCSI target to boot from.
      '';
      default = null;
      example = "iqn.2020-08.org.linux-iscsi.targethost:example";
      type = nullOr str;
    };

    loginAll = mkOption {
      description = ''
        Do not log into a specific target on the portal, but to all that we discover.
        This overrides setting target.
      '';
      type = bool;
      default = false;
    };
  };

  config = mkIf (cfg.name != null) {
    boot.initrd = {
      network.enable = true;

      kernelModules = [ "iscsi_tcp" ];

      extraUtilsCommands = ''
        copy_bin_and_libs ${pkgs.openiscsi}/bin/iscsid
        copy_bin_and_libs ${pkgs.openiscsi}/bin/iscsiadm
        ${optionalString (!config.boot.initrd.network.ssh.enable) "cp -pv ${pkgs.glibc.out}/lib/libnss_files.so.* $out/lib"}

        mkdir -p $out/etc
        cp ${config.environment.etc.hosts.source} $out/etc/hosts
        cp ${pkgs.openiscsi}/etc/iscsi/iscsid.conf $out/etc/iscsid.conf
      '';

      extraUtilsCommandsTest = ''
        $out/bin/iscsiadm --version
      '';

      preLVMCommands = ''
        ${optionalString (!config.boot.initrd.network.ssh.enable) ''
          # stolen from initrd-ssh.nix
          echo 'root:x:0:0:root:/root:/bin/ash' > /etc/passwd
          echo 'passwd: files' > /etc/nsswitch.conf
        ''}

        # oc
        cp -f $extraUtils/etc/hosts /etc/hosts

        mkdir -p /etc/iscsi /run/lock/iscsi
        echo "InitiatorName=${cfg.name}" > /etc/iscsi/initiatorname.iscsi
        cp -f $extraUtils/etc/iscsid.conf /etc/iscsi/iscsid.conf
        ${optionalString cfg.loginAll ''echo "node.startup = automatic" >> /etc/iscsi/iscsid.conf''}
        iscsid -f -n -d 9 &
        iscsiadm --mode discoverydb --type sendtargets --portal ${cfg.discoverPortal} --discover -d 9
        ${if cfg.loginAll then ''
          iscsiadm --mode node -L all
        '' else ''
          iscsiadm --mode node --targetname ${cfg.target} --login
        ''}
        pkill -9 iscsid
      '';

      postMountCommands = ''
        ln -sfn /nix/var/nix/profiles/system/init /mnt-root/init
        stage2Init=/init
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
    ];
  };
}
