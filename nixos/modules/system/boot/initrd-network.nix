{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.boot.initrd.network;

in
{

  options = {

    boot.initrd.network.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Add network connectivity support to initrd.

        Network options are configured via <literal>ip</literal> kernel
        option, according to the kernel documentation.
      '';
    };

    boot.initrd.network.ssh.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Start SSH service during initrd boot. It can be used to debug failing
        boot on a remote server, enter pasphrase for an encrypted partition etc.
        Service is killed when stage-1 boot is finished.
      '';
    };

    boot.initrd.network.ssh.port = mkOption {
      type = types.int;
      default = 22;
      description = ''
        Port on which SSH initrd service should listen.
      '';
    };

    boot.initrd.network.ssh.shell = mkOption {
      type = types.str;
      default = "/bin/ash";
      description = ''
        Login shell of the remote user. Can be used to limit actions user can do.
      '';
    };

    boot.initrd.network.ssh.hostRSAKey = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        RSA SSH private key file in the Dropbear format.

        WARNING: This key is contained insecurely in the global Nix store. Do NOT
        use your regular SSH host private keys for this purpose or you'll expose
        them to regular users!
      '';
    };

    boot.initrd.network.ssh.hostDSSKey = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        DSS SSH private key file in the Dropbear format.

        WARNING: This key is contained insecurely in the global Nix store. Do NOT
        use your regular SSH host private keys for this purpose or you'll expose
        them to regular users!
      '';
    };

    boot.initrd.network.ssh.hostECDSAKey = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        ECDSA SSH private key file in the Dropbear format.

        WARNING: This key is contained insecurely in the global Nix store. Do NOT
        use your regular SSH host private keys for this purpose or you'll expose
        them to regular users!
      '';
    };

    boot.initrd.network.ssh.authorizedKeys = mkOption {
      type = types.listOf types.str;
      default = config.users.extraUsers.root.openssh.authorizedKeys.keys;
      description = ''
        Authorized keys for the root user on initrd.
      '';
    };

  };

  config = mkIf cfg.enable {

    boot.initrd.kernelModules = [ "af_packet" ];

    boot.initrd.extraUtilsCommands = ''
      copy_bin_and_libs ${pkgs.mkinitcpio-nfs-utils}/bin/ipconfig
    '' + optionalString cfg.ssh.enable ''
      copy_bin_and_libs ${pkgs.dropbear}/bin/dropbear

      cp -pv ${pkgs.glibc}/lib/libnss_files.so.* $out/lib
    '';

    boot.initrd.extraUtilsCommandsTest = optionalString cfg.ssh.enable ''
      $out/bin/dropbear -V
    '';

    boot.initrd.postEarlyDeviceCommands = ''
      # Search for interface definitions in command line
      for o in $(cat /proc/cmdline); do
        case $o in
          ip=*)
            ipconfig $o && hasNetwork=1
            ;;
        esac
      done
    '' + optionalString cfg.ssh.enable ''
      if [ -n "$hasNetwork" ]; then
        mkdir /dev/pts
        mount -t devpts devpts /dev/pts

        mkdir -p /etc
        echo 'root:x:0:0:root:/root:${cfg.ssh.shell}' > /etc/passwd
        echo '${cfg.ssh.shell}' > /etc/shells
        echo 'passwd: files' > /etc/nsswitch.conf

        mkdir -p /var/log
        touch /var/log/lastlog

        mkdir -p /etc/dropbear
        ${optionalString (cfg.ssh.hostRSAKey != null) "ln -s ${cfg.ssh.hostRSAKey} /etc/dropbear/dropbear_rsa_host_key"}
        ${optionalString (cfg.ssh.hostDSSKey != null) "ln -s ${cfg.ssh.hostDSSKey} /etc/dropbear/dropbear_dss_host_key"}
        ${optionalString (cfg.ssh.hostECDSAKey != null) "ln -s ${cfg.ssh.hostECDSAKey} /etc/dropbear/dropbear_ecdsa_host_key"}

        mkdir -p /root/.ssh
        ${concatStrings (map (key: ''
          echo -n ${escapeShellArg key} >> /root/.ssh/authorized_keys
        '') cfg.ssh.authorizedKeys)}

        dropbear -s -j -k -E -m -p ${toString cfg.ssh.port}
      fi
    '';

  };
}
