{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf lib.mkOption lib.optional;
  inherit (lib.types) path bool listOf str port;
  cfg = config.services.darkhttpd;

  args = lib.concatStringsSep " " ([
    cfg.rootDir
    "--port ${toString cfg.port}"
    "--addr ${cfg.address}"
  ] ++ cfg.extraArgs
    ++ lib.optional cfg.hideServerId             "--no-server-id"
    ++ lib.optional config.networking.enableIPv6 "--ipv6");

in {
  options.services.darkhttpd = {
    enable = lib.mkEnableOption "DarkHTTPd web server";

    port = lib.mkOption {
      default = 80;
      type = port;
      description = ''
        Port to listen on.
        Pass 0 to let the system choose any free port for you.
      '';
    };

    address = lib.mkOption {
      default = "127.0.0.1";
      type = str;
      description = ''
        Address to listen on.
        Pass `all` to listen on all interfaces.
      '';
    };

    rootDir = lib.mkOption {
      type = path;
      description = ''
        Path from which to serve files.
      '';
    };

    hideServerId = lib.mkOption {
      type = bool;
      default = true;
      description = ''
        Don't identify the server type in headers or directory listings.
      '';
    };

    extraArgs = lib.mkOption {
      type = listOf str;
      default = [];
      description = ''
        Additional configuration passed to the executable.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.darkhttpd = {
      description = "Dark HTTPd";
      wants = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${pkgs.darkhttpd}/bin/darkhttpd ${args}";
        AmbientCapabilities = lib.mkIf (cfg.port < 1024) [ "CAP_NET_BIND_SERVICE" ];
        Restart = "on-failure";
        RestartSec = "2s";
      };
    };
  };
}
