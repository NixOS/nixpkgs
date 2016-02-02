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

    boot.initrd.network.postCommands = mkOption {
      default = "";
      type = types.lines;
      description = ''
        Shell commands to be executed after stage 1 of the
        boot has initialised the network.
      '';
    };


  };

  config = mkIf cfg.enable {

    boot.initrd.kernelModules = [ "af_packet" ];

    boot.initrd.extraUtilsCommands = ''
      copy_bin_and_libs ${pkgs.mkinitcpio-nfs-utils}/bin/ipconfig
    '';

    boot.initrd.preLVMCommands = ''
      # Search for interface definitions in command line
      for o in $(cat /proc/cmdline); do
        case $o in
          ip=*)
            ipconfig $o && hasNetwork=1
            ;;
        esac
      done

      ${cfg.postCommands}
    '';

  };

}
