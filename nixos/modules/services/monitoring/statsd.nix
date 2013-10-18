{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.statsd;

  configFile = pkgs.writeText "statsd.conf" ''
    {
      host: "${cfg.host}",
      port: "${toString cfg.port}",
      mgmt_address: "${cfg.mgmt_address}",
      mgmt_port: "${toString cfg.mgmt_port}",
      backends: [${concatMapStrings (el: ''"./backends/${el}",'') cfg.backends}],
      graphiteHost: "${cfg.graphiteHost}",
      graphitePort: "${toString cfg.graphitePort}",
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
      type = types.uniq types.string;
    };

    port = mkOption {
      description = "Port that stats listens for messages on over UDP";
      default = 8125;
      type = types.uniq types.int;
    };

    mgmt_address = mkOption {
      description = "Address to run managment TCP interface on";
      default = "127.0.0.1";
      type = types.uniq types.string;
    };

    mgmt_port = mkOption {
      description = "Port to run the management TCP interface on";
      default = 8126;
      type = types.uniq types.int;
    };

    backends = mkOption {
      description = "List of backends statsd will use for data persistance";
      default = ["graphite"];
    };

    graphiteHost = mkOption {
      description = "Hostname or IP of Graphite server";
      default = "127.0.0.1";
      type = types.uniq types.string;
    };

    graphitePort = mkOption {
      description = "Port of Graphite server";
      default = 2003;
      type = types.uniq types.int;
    };

    extraConfig = mkOption {
      default = "";
      description = "Extra configuration options for statsd";
      type = types.uniq types.string;
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
      serviceConfig = {
        ExecStart = "${pkgs.nodePackages.statsd}/bin/statsd ${configFile}";
        User = "statsd";
      };
    };

    environment.systemPackages = [pkgs.nodePackages.statsd];

  };

}
