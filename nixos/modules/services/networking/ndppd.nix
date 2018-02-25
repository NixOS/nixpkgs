{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ndppd;

  configFile = pkgs.runCommand "ndppd.conf" {} ''
    substitute ${pkgs.ndppd}/etc/ndppd.conf $out \
      --replace eth0 ${cfg.interface} \
      --replace 1111:: ${cfg.network}
  '';
in {
  options = {
    services.ndppd = {
      enable = mkEnableOption "daemon that proxies NDP (Neighbor Discovery Protocol) messages between interfaces";
      interface = mkOption {
        type = types.string;
        default = "eth0";
        example = "ens3";
        description = "Interface which is on link-level with router.";
      };
      network = mkOption {
        type = types.string;
        default = "1111::";
        example = "2001:DB8::/32";
        description = "Network that we proxy.";
      };
      configFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Path to configuration file.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.packages = [ pkgs.ndppd ];
    environment.etc."ndppd.conf".source = if (cfg.configFile != null) then cfg.configFile else configFile;
    systemd.services.ndppd = {
      serviceConfig.RuntimeDirectory = [ "ndppd" ];
      wantedBy = [ "multi-user.target" ];
    };
  };

  meta.maintainers = with maintainers; [ gnidorah ];
}
