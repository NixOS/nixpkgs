{
  config,
  options,
  lib,
  pkgs,
  ...
}:
let

  name = "snapserver";

  cfg = config.services.snapserver;

  # Using types.nullOr to inherit upstream defaults.
  sampleFormat = lib.mkOption {
    type = with lib.types; nullOr str;
    default = null;
    description = ''
      Default sample format.
    '';
    example = "48000:16:2";
  };

  codec = lib.mkOption {
    type = with lib.types; nullOr str;
    default = null;
    description = ''
      Default audio compression method.
    '';
    example = "flac";
  };

  streamToOption =
    name: opt:
    let
      os = val: lib.optionalString (val != null) "${val}";
      os' = prefix: val: lib.optionalString (val != null) (prefix + "${val}");
      toQueryString = key: value: "&${key}=${value}";
    in
    "--stream.stream=\"${opt.type}://"
    + os opt.location
    + "?"
    + os' "name=" name
    + os' "&sampleformat=" opt.sampleFormat
    + os' "&codec=" opt.codec
    + lib.concatStrings (lib.mapAttrsToList toQueryString opt.query)
    + "\"";

  optionalNull = val: ret: lib.optional (val != null) ret;

  optionString = lib.concatStringsSep " " (
    lib.mapAttrsToList streamToOption cfg.streams
    # global options
    ++ [ "--stream.bind_to_address=${cfg.listenAddress}" ]
    ++ [ "--stream.port=${toString cfg.port}" ]
    ++ optionalNull cfg.sampleFormat "--stream.sampleformat=${cfg.sampleFormat}"
    ++ optionalNull cfg.codec "--stream.codec=${cfg.codec}"
    ++ optionalNull cfg.streamBuffer "--stream.stream_buffer=${toString cfg.streamBuffer}"
    ++ optionalNull cfg.buffer "--stream.buffer=${toString cfg.buffer}"
    ++ lib.optional cfg.sendToMuted "--stream.send_to_muted"
    # tcp json rpc
    ++ [ "--tcp.enabled=${toString cfg.tcp.enable}" ]
    ++ lib.optionals cfg.tcp.enable [
      "--tcp.bind_to_address=${cfg.tcp.listenAddress}"
      "--tcp.port=${toString cfg.tcp.port}"
    ]
    # http json rpc
    ++ [ "--http.enabled=${toString cfg.http.enable}" ]
    ++ lib.optionals cfg.http.enable [
      "--http.bind_to_address=${cfg.http.listenAddress}"
      "--http.port=${toString cfg.http.port}"
    ]
    ++ lib.optional (cfg.http.docRoot != null) "--http.doc_root=\"${toString cfg.http.docRoot}\""
  );

in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "snapserver" "controlPort" ]
      [ "services" "snapserver" "tcp" "port" ]
    )
  ];

  ###### interface

  options = {

    services.snapserver = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable snapserver.
        '';
      };

      package = lib.options.mkPackageOption pkgs "snapcast" { };

      listenAddress = lib.mkOption {
        type = lib.types.str;
        default = "::";
        example = "0.0.0.0";
        description = ''
          The address where snapclients can connect.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 1704;
        description = ''
          The port that snapclients can connect to.
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to automatically open the specified ports in the firewall.
        '';
      };

      inherit sampleFormat;
      inherit codec;

      streamBuffer = lib.mkOption {
        type = with lib.types; nullOr int;
        default = null;
        description = ''
          Stream read (input) buffer in ms.
        '';
        example = 20;
      };

      buffer = lib.mkOption {
        type = with lib.types; nullOr int;
        default = null;
        description = ''
          Network buffer in ms.
        '';
        example = 1000;
      };

      sendToMuted = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Send audio to muted clients.
        '';
      };

      tcp.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to enable the JSON-RPC via TCP.
        '';
      };

      tcp.listenAddress = lib.mkOption {
        type = lib.types.str;
        default = "::";
        example = "0.0.0.0";
        description = ''
          The address where the TCP JSON-RPC listens on.
        '';
      };

      tcp.port = lib.mkOption {
        type = lib.types.port;
        default = 1705;
        description = ''
          The port where the TCP JSON-RPC listens on.
        '';
      };

      http.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to enable the JSON-RPC via HTTP.
        '';
      };

      http.listenAddress = lib.mkOption {
        type = lib.types.str;
        default = "::";
        example = "0.0.0.0";
        description = ''
          The address where the HTTP JSON-RPC listens on.
        '';
      };

      http.port = lib.mkOption {
        type = lib.types.port;
        default = 1780;
        description = ''
          The port where the HTTP JSON-RPC listens on.
        '';
      };

      http.docRoot = lib.mkOption {
        type = with lib.types; nullOr path;
        default = pkgs.snapweb;
        defaultText = lib.literalExpression "pkgs.snapweb";
        description = ''
          Path to serve from the HTTP servers root.
        '';
      };

      streams = lib.mkOption {
        type =
          with lib.types;
          attrsOf (submodule {
            options = {
              location = lib.mkOption {
                type = lib.types.oneOf [
                  lib.types.path
                  lib.types.str
                ];
                description = ''
                  For type `pipe` or `file`, the path to the pipe or file.
                  For type `librespot`, `airplay` or `process`, the path to the corresponding binary.
                  For type `tcp`, the `host:port` address to connect to or listen on.
                  For type `meta`, a list of stream names in the form `/one/two/...`. Don't forget the leading slash.
                  For type `alsa`, use an empty string.
                '';
                example = lib.literalExpression ''
                  "/path/to/pipe"
                  "/path/to/librespot"
                  "192.168.1.2:4444"
                  "/MyTCP/Spotify/MyPipe"
                '';
              };
              type = lib.mkOption {
                type = lib.types.enum [
                  "pipe"
                  "librespot"
                  "airplay"
                  "file"
                  "process"
                  "tcp"
                  "alsa"
                  "spotify"
                  "meta"
                ];
                default = "pipe";
                description = ''
                  The type of input stream.
                '';
              };
              query = lib.mkOption {
                type = attrsOf str;
                default = { };
                description = ''
                  Key-value pairs that convey additional parameters about a stream.
                '';
                example = lib.literalExpression ''
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
        default = {
          default = { };
        };
        description = ''
          The definition for an input source.
        '';
        example = lib.literalExpression ''
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

  config = lib.mkIf cfg.enable {

    warnings =
      # https://github.com/badaix/snapcast/blob/98ac8b2fb7305084376607b59173ce4097c620d8/server/streamreader/stream_manager.cpp#L85
      lib.filter (w: w != "") (
        lib.mapAttrsToList (
          k: v:
          lib.optionalString (v.type == "spotify") ''
            services.snapserver.streams.${k}.type = "spotify" is deprecated, use services.snapserver.streams.${k}.type = "librespot" instead.
          ''
        ) cfg.streams
      );

    systemd.services.snapserver = {
      after = [
        "network.target"
        "nss-lookup.target"
      ];
      description = "Snapserver";
      wantedBy = [ "multi-user.target" ];
      before = [
        "mpd.service"
        "mopidy.service"
      ];

      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${cfg.package}/bin/snapserver --daemon ${optionString}";
        Type = "forking";
        LimitRTPRIO = 50;
        LimitRTTIME = "infinity";
        NoNewPrivileges = true;
        PIDFile = "/run/${name}/pid";
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        Restart = "on-failure";
        RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX AF_NETLINK";
        RestrictNamespaces = true;
        RuntimeDirectory = name;
        StateDirectory = name;
      };
    };

    networking.firewall.allowedTCPPorts =
      lib.optionals cfg.openFirewall [ cfg.port ]
      ++ lib.optional (cfg.openFirewall && cfg.tcp.enable) cfg.tcp.port
      ++ lib.optional (cfg.openFirewall && cfg.http.enable) cfg.http.port;
  };

  meta = {
    maintainers = with lib.maintainers; [ tobim ];
  };

}
