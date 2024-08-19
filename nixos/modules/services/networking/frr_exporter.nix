{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.frr_exporter;
in
{
  options.services.frr_exporter = {
    enable = lib.mkEnableOption "FRR Exporter";

    package = lib.mkPackageOption pkgs "prometheus-frr-exporter" { };

    port = lib.mkOption {
      type = lib.types.port;
      default = 9342;
      description = "Port for FRR Exporter to run on";
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open ports in the firewall for the exporter.";
    };

    collectors = lib.mkOption {
      type = lib.types.submodule {
        options = {
          bfd = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable the bfd collector";
          };
          bgp = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable the bgp collector";
          };
          bgp6 = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable the bgp6 collector";
          };
          bgpl2vpn = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable the bgpl2vpn collector";
          };
          ospf = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable the ospf collector";
          };
          pim = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable the pim collector";
          };
          vrrp = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable the vrrp collector";
          };
        };
      };
      description = "Collectors that should be enabled";
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.frrvty = { };

    users.users.frr_exporter = {
      description = "FRR exporter user";
      isSystemUser = true;
      group = "frrvty";
    };

    systemd.services.frr_exporter = {
      wantedBy = [ "multi-user.target" ];
      requires = [ "network.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        User = "frr_exporter";
        Group = "frrvty";

        ExecStart = ''
          ${cfg.package}/bin/frr_exporter \
            --web.listen-address=:${toString cfg.port} \
            --${lib.optionalString (!cfg.collectors.bfd) "no-"}collector.bfd \
            --${lib.optionalString (!cfg.collectors.bgp) "no-"}collector.bgp \
            --${lib.optionalString (!cfg.collectors.bgp6) "no-"}collector.bgp6 \
            --${lib.optionalString (!cfg.collectors.bgpl2vpn) "no-"}collector.bgpl2vpn \
            --${lib.optionalString (!cfg.collectors.ospf) "no-"}collector.ospf \
            --${lib.optionalString (!cfg.collectors.pim) "no-"}collector.pim \
            --${lib.optionalString (!cfg.collectors.vrrp) "no-"}collector.vrrp
        '';
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf (cfg.openFirewall) [ cfg.port ];
  };
}
