{
  config,
  lib,
  pkgs,
  ...
}:
let

  name = "snapserver";

  inherit (lib)
    literalExpression
    mkEnableOption
    mkOption
    mkPackageOption
    mkRemovedOptionModule
    mkRenamedOptionModule
    types
    ;

  cfg = config.services.snapserver;

  format = pkgs.formats.ini {
    listsAsDuplicateKeys = true;
  };

  configFile = format.generate "snapserver.conf" cfg.settings;

in
{
  imports = [
    (mkRenamedOptionModule
      [ "services" "snapserver" "controlPort" ]
      [ "services" "snapserver" "tcp" "port" ]
    )

    (mkRenamedOptionModule
      [ "services" "snapserver" "listenAddress" ]
      [ "services" "snapserver" "settings" "stream" "bind_to_address" ]
    )
    (mkRenamedOptionModule
      [ "services" "snapserver" "port" ]
      [ "services" "snapserver" "settings" "stream" "port" ]
    )
    (mkRenamedOptionModule
      [ "services" "snapserver" "sampleFormat" ]
      [ "services" "snapserver" "settings" "stream" "sampleformat" ]
    )
    (mkRenamedOptionModule
      [ "services" "snapserver" "codec" ]
      [ "services" "snapserver" "settings" "stream" "codec" ]
    )
    (mkRenamedOptionModule
      [ "services" "snapserver" "streamBuffer" ]
      [ "services" "snapserver" "settings" "stream" "chunk_ms" ]
    )
    (mkRenamedOptionModule
      [ "services" "snapserver" "buffer" ]
      [ "services" "snapserver" "settings" "stream" "buffer" ]
    )
    (mkRenamedOptionModule
      [ "services" "snapserver" "send" ]
      [ "services" "snapserver" "settings" "stream" "chunk_ms" ]
    )

    (mkRenamedOptionModule
      [ "services" "snapserver" "tcp" "enable" ]
      [ "services" "snapserver" "settings" "tcp" "enabled" ]
    )
    (mkRenamedOptionModule
      [ "services" "snapserver" "tcp" "listenAddress" ]
      [ "services" "snapserver" "settings" "tcp" "bind_to_address" ]
    )
    (mkRenamedOptionModule
      [ "services" "snapserver" "tcp" "port" ]
      [ "services" "snapserver" "settings" "tcp" "port" ]
    )

    (mkRenamedOptionModule
      [ "services" "snapserver" "http" "enable" ]
      [ "services" "snapserver" "settings" "http" "enabled" ]
    )
    (mkRenamedOptionModule
      [ "services" "snapserver" "http" "listenAddress" ]
      [ "services" "snapserver" "settings" "http" "bind_to_address" ]
    )
    (mkRenamedOptionModule
      [ "services" "snapserver" "http" "port" ]
      [ "services" "snapserver" "settings" "http" "port" ]
    )
    (mkRenamedOptionModule
      [ "services" "snapserver" "http" "docRoot" ]
      [ "services" "snapserver" "settings" "http" "doc_root" ]
    )

    (mkRemovedOptionModule [
      "services"
      "snapserver"
      "streams"
    ] "Configure `services.snapserver.settings.stream.source` instead")
  ];

  ###### interface

  options = {

    services.snapserver = {

      enable = mkEnableOption "snapserver";

      package = mkPackageOption pkgs "snapcast" { };

      settings = mkOption {
        default = { };
        description = ''
          Snapserver configuration.

          Refer to the [example configuration](https://github.com/badaix/snapcast/blob/develop/server/etc/snapserver.conf) for possible options.
        '';
        type = types.submodule {
          freeformType = format.type;
          options = {
            stream = {
              bind_to_address = mkOption {
                default = "::";
                description = ''
                  Address to listen on for snapclient connections.
                '';
              };

              port = mkOption {
                type = types.port;
                default = 1704;
                description = ''
                  Port to listen on for snapclient connections.
                '';
              };

              source = mkOption {
                type = with types; either str (listOf str);
                example = "pipe:///tmp/snapfifo?name=default";
                description = ''
                  One or multiple URIs to PCM inpuit streams.
                '';
              };
            };

            tcp = {
              enabled = mkEnableOption "the TCP JSON-RPC";

              bind_to_address = mkOption {
                default = "::";
                description = ''
                  Address to listen on for snapclient connections.
                '';
              };

              port = mkOption {
                type = types.port;
                default = 1705;
                description = ''
                  Port to listen on for snapclient connections.
                '';
              };
            };

            http = {
              enabled = mkEnableOption "the HTTP JSON-RPC";

              bind_to_address = mkOption {
                default = "::";
                description = ''
                  Address to listen on for snapclient connections.
                '';
              };

              port = mkOption {
                type = types.port;
                default = 1780;
                description = ''
                  Port to listen on for snapclient connections.
                '';
              };

              doc_root = lib.mkOption {
                type = with lib.types; nullOr path;
                default = pkgs.snapweb;
                defaultText = literalExpression "pkgs.snapweb";
                description = ''
                  Path to serve from the HTTP servers root.
                '';
              };
            };
          };
        };
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to automatically open the specified ports in the firewall.
        '';
      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    environment.etc."snapserver.conf".source = configFile;

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
      restartTriggers = [ configFile ];
      serviceConfig = {
        DynamicUser = true;
        ExecStart = toString [
          (lib.getExe' cfg.package "snapserver")
          "--daemon"
        ];
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
      lib.optionals cfg.openFirewall [ cfg.settings.stream.port ]
      ++ lib.optional (cfg.openFirewall && cfg.settings.tcp.enabled) cfg.settings.tcp.port
      ++ lib.optional (cfg.openFirewall && cfg.settings.http.enabled) cfg.settings.http.port;
  };

  meta = {
    maintainers = with lib.maintainers; [ tobim ];
  };

}
