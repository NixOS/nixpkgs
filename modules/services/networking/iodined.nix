# NixOS module for iodine, ip over dns daemon

{ config, pkgs, ... }:

with pkgs.lib;

let
  cfg = config.services.iodined;

  iodinedUser = "iodined";

in

{

  ### configuration

  options = {

    services.iodined = {

      enable = mkOption {
        type = types.uniq types.bool;
        default = false;
        description = "Enable iodine, ip over dns daemon";
      };

      client = mkOption {
        type = types.uniq types.bool;
        default = false;
        description = "Start iodine in client mode";
      };

      ip = mkOption {
        type = types.uniq types.string;
        default = "";
        description = "Assigned ip address or ip range";
        example = "172.16.10.1/24";
      };

      domain = mkOption {
        type = types.uniq types.string;
        default = "";
        description = "Domain or subdomain of which nameservers point to us";
        example = "tunnel.mydomain.com";
      };

      extraConfig = mkOption {
        type = types.uniq types.string;
        default = "";
        description = "Additional command line parameters";
        example = "-P mysecurepassword -l 192.168.1.10 -p 23";
      };

    };

  };

  ### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.iodine ];
    boot.kernelModules = [ "tun" ];

    systemd.services.iodined = {
      description = "iodine, ip over dns daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = "${pkgs.iodine}/sbin/iodined -f -u ${iodinedUser} ${cfg.extraConfig} ${cfg.ip} ${cfg.domain}";
    };


    users.extraUsers = singleton {
      name = iodinedUser;
      uid = config.ids.uids.iodined;
      description = "Iodine daemon user";
    };
    users.extraGroups.iodined.gid = config.ids.gids.iodined;

    assertions = [{ assertion = if !cfg.client then cfg.ip != "" else true;
                    message = "cannot start iodined without ip set";}
                  { assertion = cfg.domain != "";
                    message = "cannot start iodined without domain name set";}];

  };

}
