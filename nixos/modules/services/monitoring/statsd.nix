{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.statsd;

  configFile = pkgs.writeText "statsd.conf" ''
    {
      address: "${cfg.host}",
      port: "${toString cfg.port}",
      mgmt_address: "${cfg.mgmt_address}",
      mgmt_port: "${toString cfg.mgmt_port}",
      backends: [${concatMapStringsSep "," (el: if (nixType el) == "string" then ''"./backends/${el}"'' else ''"${head el.names}"'') cfg.backends}],
      ${optionalString (cfg.graphiteHost!=null) ''graphiteHost: "${cfg.graphiteHost}",''}
      ${optionalString (cfg.graphitePort!=null) ''graphitePort: "${toString cfg.graphitePort}",''}
      console: {
        prettyprint: false
      },
      log: {
        backend: "syslog"
      },
      automaticConfigReload: false${optionalString (cfg.extraConfig != null) ","}
      ${cfg.extraConfig}
    }
  '';

in

{

  ###### interface

  options.services.statsd = {

    enable = mkOption {
      description = "Whether to enable statsd stats aggregation service";
      default = false;
      type = types.uniq types.bool;
    };

    host = mkOption {
      description = "Address that statsd listens on over UDP";
      default = "127.0.0.1";
      type = types.str;
    };

    port = mkOption {
      description = "Port that stats listens for messages on over UDP";
      default = 8125;
      type = types.uniq types.int;
    };

    mgmt_address = mkOption {
      description = "Address to run managment TCP interface on";
      default = "127.0.0.1";
      type = types.str;
    };

    mgmt_port = mkOption {
      description = "Port to run the management TCP interface on";
      default = 8126;
      type = types.uniq types.int;
    };

    backends = mkOption {
      description = "List of backends statsd will use for data persistance";
      default = ["graphite"];
      example = ["graphite" pkgs.nodePackages."statsd-influxdb-backend"];
      type = types.listOf (types.either types.str types.package);
    };

    graphiteHost = mkOption {
      description = "Hostname or IP of Graphite server";
      default = null;
      type = types.nullOr types.str;
    };

    graphitePort = mkOption {
      description = "Port of Graphite server (i.e. carbon-cache).";
      default = null;
      type = types.nullOr types.int;
    };

    extraConfig = mkOption {
      description = "Extra configuration options for statsd";
      default = "";
      type = types.nullOr types.str;
    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    users.extraUsers = singleton {
      name = "statsd";
      uid = config.ids.uids.statsd;
      description = "Statsd daemon user";
    };

    systemd.services.statsd = {
      description = "Statsd Server";
      wantedBy = [ "multi-user.target" ];
      environment = {
        NODE_PATH=concatMapStringsSep ":" (el: "${el}/lib/node_modules") (filter (el: (nixType el) != "string") cfg.backends);
      };
      serviceConfig = {
        ExecStart = "${pkgs.nodePackages.statsd}/bin/statsd ${configFile}";
        User = "statsd";
      };
    };

    environment.systemPackages = [pkgs.nodePackages.statsd];

  };

}
