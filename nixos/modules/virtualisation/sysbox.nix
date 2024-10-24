{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.virtualisation.sysbox;
in

{
  ###### interface

  options.virtualisation.sysbox = {
    enable =
      mkOption {
        type = types.bool;
        default = false;
        description =
          lib.mdDoc ''
            This option enables sysbox
          '';
        };

    package = mkPackageOption pkgs "sysbox" { };
  };

  ###### implementation

  config = mkIf cfg.enable {
    systemd.services.sysbox-mgr = {
      description = "Sysbox Manager Service";
      wantedBy = [ "multi-user.target" ];

      path = [ pkgs.rsync pkgs.kmod pkgs.iptables ];
      script = "${cfg.package}/bin/sysbox-mgr";

      preStart = ''
        mkdir /sbin || true
        cp ${pkgs.iptables}/bin/* /sbin || true
      '';

      serviceConfig = {
        User = "root";
        Group = "root";
      };
    };

    systemd.services.sysbox-fs = {
      description = "Sysbox FileSystem Service";
      wantedBy = [ "multi-user.target" ];

      path = [ pkgs.rsync pkgs.kmod pkgs.fuse pkgs.iptables ];
      script = "${cfg.package}/bin/sysbox-fs";

      serviceConfig = {
        User = "root";
        Group = "root";
      };
    };

    virtualisation.docker.extraOptions = ''--add-runtime=sysbox=${cfg.package}/bin/sysbox-runc'';

    security.unprivilegedUsernsClone = true;

    assertions = [
      { assertion = !virtualisation.docker.enable;
        message = "Sysbox require docker to be functional";
      }
      { assertion = virtualisation.podman.enable;
        message = "Sysbox require docker to be functional";
      }
    ];
  };
}
