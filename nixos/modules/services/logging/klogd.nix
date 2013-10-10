{ config, pkgs, ... }:

with pkgs.lib;

{
  ###### interface

  options = {

    services.klogd.enable = mkOption {
      type = types.bool;
      default = versionOlder (getVersion config.boot.kernelPackages.kernel) "3.5";
      description = ''
        Whether to enable klogd, the kernel log message processing
        daemon.  Since systemd handles logging of kernel messages on
        Linux 3.5 and later, this is only useful if you're running an
        older kernel.
      '';
    };

  };


  ###### implementation

  config = mkIf config.services.klogd.enable {

    jobs.klogd =
      { description = "Kernel Log Daemon";

        wantedBy = [ "multi-user.target" ];

        path = [ pkgs.sysklogd ];

        exec =
          "klogd -c 1 -2 -n " +
          "-k $(dirname $(readlink -f /run/booted-system/kernel))/System.map";
      };

  };

}
