{ config, pkgs, ... }:

with pkgs.lib;

let
  cfg = config.services.dd-agent;

  datadog_conf = pkgs.runCommand "datadog.conf" {} ''
    sed -e 's|^api_key:|api_key: ${cfg.api_key}|' ${optionalString (cfg.hostname != null)
      "-e 's|^#hostname: mymachine.mydomain|hostname: ${cfg.hostname}|'"
    } ${pkgs.dd-agent}/etc/dd-agent/datadog.conf.example > $out
  '';
in {
  options.services.dd-agent = {
    enable = mkOption {
      description = "Whether to enable the dd-agent montioring service";

      default = false;

      type = types.bool;
    };

    # !!! This gets stored in the store (world-readable), wish we had https://github.com/NixOS/nix/issues/8
    api_key = mkOption {
      description = "The Datadog API key to associate the agent with your account";

      example = "ae0aa6a8f08efa988ba0a17578f009ab";

      type = types.str;
    };

    hostname = mkOption {
      description = "The hostname to show in the Datadog dashboard (optional)";

      default = null;

      example = "mymachine.mydomain";

      type = types.uniq (types.nullOr types.string);
    };
  };

  config = mkIf cfg.enable {
    environment.etc = [ { source = datadog_conf; target = "dd-agent/datadog.conf"; } ];
    environment.systemPackages = [ pkgs."dd-agent" pkgs.sysstat pkgs.procps ];

    users.extraUsers."dd-agent" = {
      description = "Datadog Agent User";
      uid = config.ids.uids.dd-agent;
      group = "dd-agent";
      home = "/var/log/datadog/";
      createHome = true;
    };

    users.extraGroups.dd-agent.gid = config.ids.gids.dd-agent;

    systemd.services.dd-agent = {
      description = "Datadog agent monitor";
      path = [ pkgs."dd-agent" pkgs.python pkgs.sysstat pkgs.procps];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.dd-agent}/bin/dd-agent foreground";
        User = "dd-agent";
        Group = "dd-agent";
        Restart = "always";
        RestartSec = 2;
      };
      restartTriggers = [ pkgs.dd-agent datadog_conf ];
    };

    systemd.services.dogstatsd = {
      description = "Datadog statsd";
      path = [ pkgs."dd-agent" pkgs.python ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.dd-agent}/bin/dogstatsd start";
        User = "dd-agent";
        Group = "dd-agent";
        Type = "forking";
        PIDFile = "/tmp/dogstatsd.pid";
        Restart = "always";
        RestartSec = 2;
      };
      restartTriggers = [ pkgs.dd-agent datadog_conf ];
    };
  };
}
