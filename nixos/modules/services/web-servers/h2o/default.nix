{
  config,
  lib,
  pkgs,
  ...
}:

# TODO: ACME
# TODO: Gems includes for Mruby
# TODO: Recommended options
let
  cfg = config.services.h2o;

  inherit (lib)
    literalExpression
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  settingsFormat = pkgs.formats.yaml { };

  hostsConfig = lib.concatMapAttrs (
    name: value:
    let
      port = {
        HTTP = lib.attrByPath [ "http" "port" ] cfg.defaultHTTPListenPort value;
        TLS = lib.attrByPath [ "tls" "port" ] cfg.defaultTLSListenPort value;
      };
      serverName = if value.serverName != null then value.serverName else name;
    in
    # HTTP settings
    lib.optionalAttrs (value.tls == null || value.tls.policy == "add") {
      "${serverName}:${builtins.toString port.HTTP}" = value.settings // {
        listen.port = port.HTTP;
      };
    }
    # Redirect settings
    // lib.optionalAttrs (value.tls != null && value.tls.policy == "force") {
      "${serverName}:${builtins.toString port.HTTP}" = {
        listen.port = port.HTTP;
        paths."/" = {
          redirect = {
            status = value.tls.redirectCode;
            url = "https://${serverName}:${builtins.toString port.TLS}";
          };
        };
      };
    }
    # TLS settings
    //
      lib.optionalAttrs
        (
          value.tls != null
          && builtins.elem value.tls.policy [
            "add"
            "only"
            "force"
          ]
        )
        {
          "${serverName}:${builtins.toString port.TLS}" = value.settings // {
            listen =
              let
                identity = value.tls.identity;
              in
              {
                port = port.TLS;
                ssl = value.tls.extraSettings or { } // {
                  inherit identity;
                };
              };
          };
        }
  ) cfg.hosts;

  h2oConfig = settingsFormat.generate "h2o.yaml" (
    lib.recursiveUpdate { hosts = hostsConfig; } cfg.settings
  );
in
{
  options = {
    services.h2o = {
      enable = mkEnableOption "H2O web server";

      user = mkOption {
        type = types.nonEmptyStr;
        default = "h2o";
        description = "User running H2O service";
      };

      group = mkOption {
        type = types.nonEmptyStr;
        default = "h2o";
        description = "Group running H2O services";
      };

      package = lib.mkPackageOption pkgs "h2o" {
        example = ''
          pkgs.h2o.override {
            withMruby = true;
          };
        '';
      };

      defaultHTTPListenPort = mkOption {
        type = types.port;
        default = 80;
        description = ''
          If hosts do not specify listen.port, use these ports for HTTP by default.
        '';
        example = 8080;
      };

      defaultTLSListenPort = mkOption {
        type = types.port;
        default = 443;
        description = ''
          If hosts do not specify listen.port, use these ports for SSL by default.
        '';
        example = 8443;
      };

      mode = mkOption {
        type =
          with types;
          nullOr (enum [
            "daemon"
            "master"
            "worker"
            "test"
          ]);
        default = "master";
        description = "Operating mode of H2O";
      };

      settings = mkOption {
        type = settingsFormat.type;
        default = { };
        description = "Configuration for H2O (see <https://h2o.examp1e.net/configure.html>)";
      };

      hosts = mkOption {
        type = types.attrsOf (
          types.submodule (
            import ./vhost-options.nix {
              inherit config lib;
            }
          )
        );
        default = { };
        description = ''
          The `hosts` config to be merged with the settings.

          Note that unlike YAML used for H2O, Nix will not support duplicate
          keys to, for instance, have multiple listens in a host block; use the
          virtual host options in like `http` & `tls` or use `$HOST:$PORT`
          keys if manually specifying config.
        '';
        example =
          literalExpression
            # nix
            ''
              {
                "hydra.example.com" = {
                  tls = {
                    policy = "force";
                    indentity = [
                      {
                        key-file = "/path/to/key";
                        certificate-file = "/path/to/cert";
                      };
                    ];
                    extraSettings = {
                      minimum-version = "TLSv1.3";
                    };
                  };
                  settings = {
                    paths."/" = {
                      "file:dir" = "/var/www/default";
                    };
                  };
                };
              }
            '';
      };
    };
  };

  config = mkIf cfg.enable {
    users = {
      users.${cfg.user} =
        {
          group = cfg.group;
        }
        // lib.optionalAttrs (cfg.user == "h2o") {
          isSystemUser = true;
        };
      groups.${cfg.group} = { };
    };

    systemd.services.h2o = {
      description = "H2O HTTP server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        ExecStop = "${pkgs.coreutils}/bin/kill -s QUIT $MAINPID";
        User = cfg.user;
        Group = cfg.group;
        Restart = "always";
        RestartSec = "10s";
        RuntimeDirectory = "h2o";
        RuntimeDirectoryMode = "0750";
        CacheDirectory = "h2o";
        CacheDirectoryMode = "0750";
        LogsDirectory = "h2o";
        LogsDirectoryMode = "0750";
        ProtectSystem = "strict";
        ProtectHome = mkDefault true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        PrivateMounts = true;
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilitiesBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
      };

      script =
        let
          args =
            [
              "--conf"
              "${h2oConfig}"
            ]
            ++ lib.optionals (cfg.mode != null) [
              "--mode"
              cfg.mode
            ];
        in
        ''
          ${lib.getExe cfg.package} ${lib.strings.escapeShellArgs args}
        '';
    };
  };

}
