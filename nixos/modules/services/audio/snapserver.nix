{ config, lib, pkgs, ... }:

with lib;

let

  name = "snapserver";

  cfg = config.services.snapserver;

  # Using types.nullOr to inherit upstream defaults.
  sampleFormat = mkOption {
    type = with types; nullOr str;
    default = null;
    description = ''
      Default sample format.
    '';
    example = "48000:16:2";
  };

  codec = mkOption {
    type = with types; nullOr str;
    default = null;
    description = ''
      Default audio compression method.
    '';
    example = "flac";
  };

  streamToOption = name: opt:
    let
      os = val:
        optionalString (val != null) "${val}";
      os' = prefixx: val:
        optionalString (val != null) (prefixx + "${val}");
      flatten = key: value:
        "&${key}=${value}";
    in
      "-s ${opt.type}://" + os opt.location + "?" + os' "name=" name
        + concatStrings (mapAttrsToList flatten opt.query);

  optionalNull = val: ret:
    optional (val != null) ret;

  optionString = concatStringsSep " " (mapAttrsToList streamToOption cfg.streams
             ++ ["-p ${toString cfg.port}"]
             ++ ["--controlPort ${toString cfg.controlPort}"]
             ++ optionalNull cfg.sampleFormat "--sampleFormat ${cfg.sampleFormat}"
             ++ optionalNull cfg.codec "-c ${cfg.codec}"
             ++ optionalNull cfg.streamBuffer "--streamBuffer ${cfg.streamBuffer}"
             ++ optionalNull cfg.buffer "-b ${cfg.buffer}"
             ++ optional cfg.sendToMuted "--sendToMuted");

in {

  ###### interface

  options = {

    services.snapserver = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable snapserver.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 1704;
        description = ''
          The port that snapclients can connect to.
        '';
      };

      controlPort = mkOption {
        type = types.port;
        default = 1705;
        description = ''
          The port for control connections (JSON-RPC).
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to automatically open the specified ports in the firewall.
        '';
      };

      inherit sampleFormat;
      inherit codec;

      streams = mkOption {
        type = with types; attrsOf (submodule {
          options = {
            location = mkOption {
              type = types.path;
              description = ''
                The location of the pipe.
              '';
            };
            type = mkOption {
              type = types.enum [ "pipe" "file" "process" "spotify" "airplay" ];
              default = "pipe";
              description = ''
                The type of input stream.
              '';
            };
            query = mkOption {
              type = attrsOf str;
              default = {};
              description = ''
                Key-value pairs that convey additional parameters about a stream.
              '';
              example = literalExample ''
                # for type == "pipe":
                {
                  mode = "listen";
                };
                # for type == "process":
                {
                  params = "--param1 --param2";
                  logStderr = "true";
                };
              '';
            };
            inherit sampleFormat;
            inherit codec;
          };
        });
        default = { default = {}; };
        description = ''
          The definition for an input source.
        '';
        example = literalExample ''
          {
            mpd = {
              type = "pipe";
              location = "/run/snapserver/mpd";
              sampleFormat = "48000:16:2";
              codec = "pcm";
            };
          };
        '';
      };

      streamBuffer = mkOption {
        type = with types; nullOr int;
        default = null;
        description = ''
          Stream read (input) buffer in ms.
        '';
        example = 20;
      };

      buffer = mkOption {
        type = with types; nullOr int;
        default = null;
        description = ''
          Network buffer in ms.
        '';
        example = 1000;
      };

      sendToMuted = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Send audio to muted clients.
        '';
      };
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    systemd.services.snapserver = {
      after = [ "network.target" ];
      description = "Snapserver";
      wantedBy = [ "multi-user.target" ];
      before = [ "mpd.service" "mopidy.service" ];

      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${pkgs.snapcast}/bin/snapserver --daemon ${optionString}";
        Type = "forking";
        LimitRTPRIO = 50;
        LimitRTTIME = "infinity";
        NoNewPrivileges = true;
        PIDFile = "/run/${name}/pid";
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX";
        RestrictNamespaces = true;
        RuntimeDirectory = name;
        StateDirectory = name;
      };
    };

    networking.firewall.allowedTCPPorts = optionals cfg.openFirewall [ cfg.port cfg.controlPort ];
  };

  meta = {
    maintainers = with maintainers; [ tobim ];
  };

}
