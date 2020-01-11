{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.statsd;

  isBuiltinBackend = name:
    builtins.elem name [ "graphite" "console" "repeater" ];

  backendsToPackages = let
    mkMap = list: name:
      if isBuiltinBackend name then list
      else list ++ [ pkgs.nodePackages.${name} ];
  in foldl mkMap [];

  configFile = pkgs.writeText "statsd.conf" ''
    {
      address: "${cfg.listenAddress}",
      port: "${toString cfg.port}",
      mgmt_address: "${cfg.mgmt_address}",
      mgmt_port: "${toString cfg.mgmt_port}",
      backends: [${
        concatMapStringsSep "," (name:
          if (isBuiltinBackend name)
          then ''"./backends/${name}"''
          else ''"${name}"''
        ) cfg.backends}],
      ${optionalString (cfg.graphiteHost!=null) ''graphiteHost: "${cfg.graphiteHost}",''}
      ${optionalString (cfg.graphitePort!=null) ''graphitePort: "${toString cfg.graphitePort}",''}
      console: {
        prettyprint: false
      },
      log: {
        backend: "stdout"
      },
      automaticConfigReload: false${optionalString (cfg.extraConfig != null) ","}
      ${cfg.extraConfig}
    }
  '';

  deps = pkgs.buildEnv {
    name = "statsd-runtime-deps";
    pathsToLink = [ "/lib" ];
    ignoreCollisions = true;

    paths = backendsToPackages cfg.backends;
  };

in

{

  ###### interface

  options.services.statsd = {

    enable = mkEnableOption "statsd";

    listenAddress = mkOption {
      description = "Address that statsd listens on over UDP";
      default = "127.0.0.1";
      type = types.str;
    };

    port = mkOption {
      description = "Port that stats listens for messages on over UDP";
      default = 8125;
      type = types.int;
    };

    mgmt_address = mkOption {
      description = "Address to run management TCP interface on";
      default = "127.0.0.1";
      type = types.str;
    };

    mgmt_port = mkOption {
      description = "Port to run the management TCP interface on";
      default = 8126;
      type = types.int;
    };

    backends = mkOption {
      description = "List of backends statsd will use for data persistence";
      default = [];
      example = [
        "graphite"
        "console"
        "repeater"
        "statsd-librato-backend"
        "stackdriver-statsd-backend"
        "statsd-influxdb-backend"
      ];
      type = types.listOf types.str;
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

    assertions = map (backend: {
      assertion = !isBuiltinBackend backend -> hasAttrByPath [ backend ] pkgs.nodePackages;
      message = "Only builtin backends (graphite, console, repeater) or backends enumerated in `pkgs.nodePackages` are allowed!";
    }) cfg.backends;

    users.use.statsdrs = {
      uid = config.ids.uids.statsd;
      description = "Statsd daemon user";
    };

    systemd.services.statsd = {
      description = "Statsd Server";
      wantedBy = [ "multi-user.target" ];
      environment = {
        NODE_PATH = "${deps}/lib/node_modules";
      };
      serviceConfig = {
        ExecStart = "${pkgs.statsd}/bin/statsd ${configFile}";
        User = "statsd";
      };
    };

    environment.systemPackages = [ pkgs.statsd ];

  };

}
