{ pkgs, lib, config, options, ... }:

with lib;

let
  cfg = config.services.godns;

  settingsFormat = pkgs.formats.json {};
  settingsFile = settingsFormat.generate "godns.json" ({
    ip_url = "https://ip4.seeip.org";
    ipv6_url = "https://ip6.seeip.org";
    ip_type = "IPv4";
    interval = 300;
    resolver = "8.8.8.8";
  } // cfg.settings);

in
{
  options = {
    services.godns = {
      enable = mkEnableOption "GoDNS";

      package = mkOption {
        type = types.package;
        default = pkgs.godns;
        defaultText = literalExpression "pkgs.godns";
        description = "GoDNS package to use";
      };

      settings = mkOption {
        type = types.submodule {
          freeformType = settingsFormat.type;
        };
        example = {
          provider = "Cloudflare";
          email = "example@example.com";
          login_token = "";
          domains = [{
            domain_name = "example.com";
            sub_domains = ["www"];
          }];
        };
        description = "Settings used by GoDNS.";
      };

      user = mkOption {
        type = types.str;
        default = "godns";
        description = "User under which godns runs.";
      };

      group = mkOption {
        type = types.str;
        default = "godns";
        description = "Group under which godns runs.";
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/godns";
        description = "GoDNS data directory.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0700 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.godns = {
      description = "GoDNS";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/godns -c ${settingsFile}";
        Restart = "on-failure";
      };
    };

    users.users = mkIf (cfg.user == "godns") {
      godns = {
        description = "GoDNS service user";
        group = cfg.group;
        home = cfg.dataDir;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "godns") {
      godns = {};
    };
  };
}
