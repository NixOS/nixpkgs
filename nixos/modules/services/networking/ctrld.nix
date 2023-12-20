{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ctrld;
  settingsFormat = pkgs.formats.toml {};
in {

  options.services.ctrld = {
    enable = mkEnableOption "ctrld, a highly configurable DNS forwarding proxy";

    package = mkPackageOption pkgs "ctrld" {};

    settings = mkOption {
      type = settingsFormat.type;

      default = {};

      # https://github.com/Control-D-Inc/ctrld/blob/main/README.md#default-config
      example = {
        listener."listener.0" = {
          ip = "";
          port = 0;
          restricted = false;
        };

        network."network.0" = {
          cidrs = [ "0.0.0.0/0" ];
          name = "Network 0";
        };

        service = {
          log_level = "info";
          log_path = "";
        };

        upstream = {
          "upstream.0" = {
            bootstrap_ip = "76.76.2.11";
            endpoint = "https://freedns.controld.com/p1";
            name = "Control D - Anti-Malware";
            timeout = 5000;
            type = "doh";
          };

          "upstream.1" = {
            bootstrap_ip = "76.76.2.11";
            endpoint = "p2.freedns.controld.com";
            name = "Control D - No Ads";
            timeout = 3000;
            type = "doq";
          };
        };
      };

      description = ''
        Configuration for ctrld, see
        <https://github.com/Control-D-Inc/ctrld/blob/main/docs/config.md>
      '';
    };
  };

  config = mkIf cfg.enable {
    networking.nameservers = [ "127.0.0.1" ];

    systemd.services.ctrld = {
      description = "Multiclient DNS forwarding proxy";
      startLimitIntervalSec = 5;
      startLimitBurst = 10;
      serviceConfig = {
        ExecStart = "${getExe cfg.package} start --config ${settingsFormat.generate "ctrld.toml" cfg.settings}";
        Restart = "always";
      };
      before = [ "nss-lookup.target" ];
      wants = [ "network-online.target" "nss-lookup.target" ];
      wantedBy = [ "multi-user.target" ];
    };
  };

  meta.maintainers = with maintainers; [ arthsmn ];
}
