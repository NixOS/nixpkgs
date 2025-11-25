{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.statsd;

  isBuiltinBackend =
    name:
    builtins.elem name [
      "graphite"
      "console"
      "repeater"
    ];

  backendsToPackages =
    let
      mkMap = list: name: if isBuiltinBackend name then list else list ++ [ pkgs.nodePackages.${name} ];
    in
    lib.foldl mkMap [ ];

  configFile = pkgs.writeText "statsd.conf" ''
    {
      address: "${cfg.listenAddress}",
      port: "${toString cfg.port}",
      mgmt_address: "${cfg.mgmt_address}",
      mgmt_port: "${toString cfg.mgmt_port}",
      backends: [${
        lib.concatMapStringsSep "," (
          name: if (isBuiltinBackend name) then ''"./backends/${name}"'' else ''"${name}"''
        ) cfg.backends
      }],
      ${lib.optionalString (cfg.graphiteHost != null) ''graphiteHost: "${cfg.graphiteHost}",''}
      ${lib.optionalString (cfg.graphitePort != null) ''graphitePort: "${toString cfg.graphitePort}",''}
      console: {
        prettyprint: false
      },
      log: {
        backend: "stdout"
      },
      automaticConfigReload: false${lib.optionalString (cfg.extraConfig != null) ","}
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

    enable = lib.mkEnableOption "statsd";

    listenAddress = lib.mkOption {
      description = "Address that statsd listens on over UDP";
      default = "127.0.0.1";
      type = lib.types.str;
    };

    port = lib.mkOption {
      description = "Port that stats listens for messages on over UDP";
      default = 8125;
      type = lib.types.port;
    };

    mgmt_address = lib.mkOption {
      description = "Address to run management TCP interface on";
      default = "127.0.0.1";
      type = lib.types.str;
    };

    mgmt_port = lib.mkOption {
      description = "Port to run the management TCP interface on";
      default = 8126;
      type = lib.types.port;
    };

    backends = lib.mkOption {
      description = "List of backends statsd will use for data persistence";
      default = [ ];
      example = [
        "graphite"
        "console"
        "repeater"
        "statsd-librato-backend"
        "statsd-influxdb-backend"
      ];
      type = lib.types.listOf lib.types.str;
    };

    graphiteHost = lib.mkOption {
      description = "Hostname or IP of Graphite server";
      default = null;
      type = lib.types.nullOr lib.types.str;
    };

    graphitePort = lib.mkOption {
      description = "Port of Graphite server (i.e. carbon-cache).";
      default = null;
      type = lib.types.nullOr lib.types.port;
    };

    extraConfig = lib.mkOption {
      description = "Extra configuration options for statsd";
      default = "";
      type = lib.types.nullOr lib.types.str;
    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    assertions = map (backend: {
      assertion = !isBuiltinBackend backend -> lib.hasAttrByPath [ backend ] pkgs.nodePackages;
      message = "Only builtin backends (graphite, console, repeater) or backends enumerated in `pkgs.nodePackages` are allowed!";
    }) cfg.backends;

    users.users.statsd = {
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
