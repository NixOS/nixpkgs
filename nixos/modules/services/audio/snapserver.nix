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
      os' = prefix: val:
        optionalString (val != null) (prefix + "${val}");
      flatten = key: value:
        "&${key}=${value}";
    in
      "--stream.stream=\"${opt.type}://" + os opt.location + "?" + os' "name=" name
        + concatStrings (mapAttrsToList flatten opt.query) + "\"";

  optionalNull = val: ret:
    optional (val != null) ret;

  optionString = concatStringsSep " " (mapAttrsToList streamToOption cfg.streams
    # global options
    ++ [ "--stream.bind_to_address=${cfg.listenAddress}" ]
    ++ [ "--stream.port=${toString cfg.port}" ]
    ++ optionalNull cfg.sampleFormat "--stream.sampleformat=${cfg.sampleFormat}"
    ++ optionalNull cfg.codec "--stream.codec=${cfg.codec}"
    ++ optionalNull cfg.streamBuffer "--stream.stream_buffer=${toString cfg.streamBuffer}"
    ++ optionalNull cfg.buffer "--stream.buffer=${toString cfg.buffer}"
    ++ optional cfg.sendToMuted "--stream.send_to_muted"
    # tcp json rpc
    ++ [ "--tcp.enabled=${toString cfg.tcp.enable}" ]
    ++ optionals cfg.tcp.enable [
      "--tcp.bind_to_address=${cfg.tcp.listenAddress}"
      "--tcp.port=${toString cfg.tcp.port}" ]
     # http json rpc
    ++ [ "--http.enabled=${toString cfg.http.enable}" ]
    ++ optionals cfg.http.enable [
      "--http.bind_to_address=${cfg.http.listenAddress}"
      "--http.port=${toString cfg.http.port}"
    ] ++ optional (cfg.http.docRoot != null) "--http.doc_root=\"${toString cfg.http.docRoot}\"");

in {
  imports = [
    (mkRenamedOptionModule [ "services" "snapserver" "controlPort" ] [ "services" "snapserver" "tcp" "port" ])
  ];

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

      listenAddress = mkOption {
        type = types.str;
        default = "::";
        example = "0.0.0.0";
        description = ''
          The address where snapclients can connect.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 1704;
        description = ''
          The port that snapclients can connect to.
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

      tcp.enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable the JSON-RPC via TCP.
        '';
      };

      tcp.listenAddress = mkOption {
        type = types.str;
        default = "::";
        example = "0.0.0.0";
        description = ''
          The address where the TCP JSON-RPC listens on.
        '';
      };

      tcp.port = mkOption {
        type = types.port;
        default = 1705;
        description = ''
          The port where the TCP JSON-RPC listens on.
        '';
      };

      http.enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable the JSON-RPC via HTTP.
        '';
      };

      http.listenAddress = mkOption {
        type = types.str;
        default = "::";
        example = "0.0.0.0";
        description = ''
          The address where the HTTP JSON-RPC listens on.
        '';
      };

      http.port = mkOption {
        type = types.port;
        default = 1780;
        description = ''
          The port where the HTTP JSON-RPC listens on.
        '';
      };

      http.docRoot = mkOption {
        type = with types; nullOr path;
        default = null;
        description = ''
          Path to serve from the HTTP servers root.
        '';
      };

      streams = mkOption {
        type = with types; attrsOf (submodule {
          options = {
            location = mkOption {
              type = types.oneOf [ types.path types.str ];
              description = ''
                For type <literal>pipe</literal> or <literal>file</literal>, the path to the pipe or file.
                For type <literal>librespot</literal>, <literal>airplay</literal> or <literal>process</literal>, the path to the corresponding binary.
                For type <literal>tcp</literal>, the <literal>host:port</literal> address to connect to or listen on.
                For type <literal>meta</literal>, a list of stream names in the form <literal>/one/two/...</literal>. Don't forget the leading slash.
                For type <literal>alsa</literal>, use an empty string.
              '';
              example = literalExpression ''
                "/path/to/pipe"
                "/path/to/librespot"
                "192.168.1.2:4444"
                "/MyTCP/Spotify/MyPipe"
              '';
            };
            type = mkOption {
              type = types.enum [ "pipe" "librespot" "airplay" "file" "process" "tcp" "alsa" "spotify" "meta" ];
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
              example = literalExpression ''
                # for type == "pipe":
                {
                  mode = "create";
                };
                # for type == "process":
                {
                  params = "--param1 --param2";
                  logStderr = "true";
                };
                # for type == "tcp":
                {
                  mode = "client";
                }
                # for type == "alsa":
                {
                  device = "hw:0,0";
                }
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
        example = literalExpression ''
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
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    # https://github.com/badaix/snapcast/blob/98ac8b2fb7305084376607b59173ce4097c620d8/server/streamreader/stream_manager.cpp#L85
    warnings = filter (w: w != "") (mapAttrsToList (k: v: if v.type == "spotify" then ''
      services.snapserver.streams.${k}.type = "spotify" is deprecated, use services.snapserver.streams.${k}.type = "librespot" instead.
    '' else "") cfg.streams);

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
        RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX AF_NETLINK";
        RestrictNamespaces = true;
        RuntimeDirectory = name;
        StateDirectory = name;
      };
    };

    networking.firewall.allowedTCPPorts =
      optionals cfg.openFirewall [ cfg.port ]
      ++ optional cfg.tcp.enable cfg.tcp.port
      ++ optional cfg.http.enable cfg.http.port;
  };

  meta = {
    maintainers = with maintainers; [ tobim ];
  };

}
