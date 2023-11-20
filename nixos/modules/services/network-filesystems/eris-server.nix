{ config, lib, pkgs, ... }:

let
  cfg = config.services.eris-server;
  stateDirectoryPath = "\${STATE_DIRECTORY}";
in {

  options.services.eris-server = {

    enable = lib.mkEnableOption "an ERIS server";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.eris-go;
      defaultText = lib.literalExpression "pkgs.eris-go";
      description = "Package to use for the ERIS server.";
    };

    decode = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether the HTTP service (when enabled) will decode ERIS content at /uri-res/N2R?urn:eris:.
        Enabling this is recommended only for private or local-only servers.
      '';
    };

    listenCoap = lib.mkOption {
      type = lib.types.str;
      default = ":5683";
      example = "[::1]:5683";
      description = ''
        Server CoAP listen address. Listen on all IP addresses at port 5683 by default.
        Please note that the server can service client requests for ERIS-blocks by
        querying other clients connected to the server. Whether or not blocks are
        relayed back to the server depends on client configuration but be aware this
        may leak sensitive metadata and trigger network activity.
      '';
    };

    listenHttp = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "[::1]:8080";
      description = "Server HTTP listen address. Do not listen by default.";
    };

    backends = lib.mkOption {
      type = with lib.types; listOf str;
      description = ''
        List of backend URLs.
        Add "get" and "put" as query elements to enable those operations.
      '';
      example = [
        "bolt+file:///srv/eris.bolt?get&put"
        "coap+tcp://eris.example.com:5683?get"
      ];
    };

    mountpoint = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "/eris";
      description = ''
        Mountpoint for FUSE namespace that exposes "urn:eris:…" files.
      '';
    };

  };

  config = lib.mkIf cfg.enable {
    systemd.services.eris-server = let
      cmd =
        "${cfg.package}/bin/eris-go server --coap '${cfg.listenCoap}' --http '${cfg.listenHttp}' ${
          lib.optionalString cfg.decode "--decode "
        }${
          lib.optionalString (cfg.mountpoint != "")
          ''--mountpoint "${cfg.mountpoint}" ''
        }${lib.strings.escapeShellArgs cfg.backends}";
    in {
      description = "ERIS block server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      script = lib.mkIf (cfg.mountpoint != "") ''
        export PATH=${config.security.wrapperDir}:$PATH
        ${cmd}
      '';
      serviceConfig = let
        umounter = lib.mkIf (cfg.mountpoint != "")
          "-${config.security.wrapperDir}/fusermount -uz ${cfg.mountpoint}";
      in {
        ExecStartPre = umounter;
        ExecStart = lib.mkIf (cfg.mountpoint == "") cmd;
        ExecStopPost = umounter;
        Restart = "always";
        RestartSec = 20;
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ ehmry ];
}
