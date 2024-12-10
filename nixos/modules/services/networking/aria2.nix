{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.aria2;

  homeDir = "/var/lib/aria2";
  defaultRpcListenPort = 6800;
  defaultDir = "${homeDir}/Downloads";

  portRangesToString =
    ranges:
    lib.concatStringsSep "," (
      map (
        x:
        if x.from == x.to then
          builtins.toString x.from
        else
          builtins.toString x.from + "-" + builtins.toString x.to
      ) ranges
    );

  customToKeyValue = lib.generators.toKeyValue {
    mkKeyValue = lib.generators.mkKeyValueDefault {
      mkValueString =
        v: if builtins.isList v then portRangesToString v else lib.generators.mkValueStringDefault { } v;
    } "=";
  };
in
{
  imports = [
    (lib.mkRemovedOptionModule [
      "services"
      "aria2"
      "rpcSecret"
    ] "Use services.aria2.rpcSecretFile instead")
    (lib.mkRemovedOptionModule [
      "services"
      "aria2"
      "extraArguments"
    ] "Use services.aria2.settings instead")
    (lib.mkRenamedOptionModule
      [ "services" "aria2" "downloadDir" ]
      [ "services" "aria2" "settings" "dir" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "aria2" "listenPortRange" ]
      [ "services" "aria2" "settings" "listen-port" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "aria2" "rpcListenPort" ]
      [ "services" "aria2" "settings" "rpc-listen-port" ]
    )
  ];

  options = {
    services.aria2 = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether or not to enable the headless Aria2 daemon service.

          Aria2 daemon can be controlled via the RPC interface using one of many
          WebUIs (http://localhost:${toString defaultRpcListenPort}/ by default).

          Targets are downloaded to `${defaultDir}` by default and are
          accessible to users in the `aria2` group.
        '';
      };
      openPorts = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Open listen and RPC ports found in `settings.listen-port` and
          `settings.rpc-listen-port` options in the firewall.
        '';
      };
      rpcSecretFile = lib.mkOption {
        type = lib.types.path;
        example = "/run/secrets/aria2-rpc-token.txt";
        description = ''
          A file containing the RPC secret authorization token.
          Read https://aria2.github.io/manual/en/html/aria2c.html#rpc-auth to know how this option value is used.
        '';
      };
      settings = lib.mkOption {
        description = ''
          Generates the `aria2.conf` file. Refer to [the documentation][0] for
          all possible settings.

          [0]: https://aria2.github.io/manual/en/html/aria2c.html#synopsis
        '';
        default = { };
        type = lib.types.submodule {
          freeformType =
            with lib.types;
            attrsOf (oneOf [
              bool
              int
              float
              singleLineStr
            ]);
          options = {
            save-session = lib.mkOption {
              type = lib.types.singleLineStr;
              default = "${homeDir}/aria2.session";
              description = "Save error/unfinished downloads to FILE on exit.";
            };
            dir = lib.mkOption {
              type = lib.types.singleLineStr;
              default = defaultDir;
              description = "Directory to store downloaded files.";
            };
            conf-path = lib.mkOption {
              type = lib.types.singleLineStr;
              default = "${homeDir}/aria2.conf";
              description = "Configuration file path.";
            };
            enable-rpc = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Enable JSON-RPC/XML-RPC server.";
            };
            listen-port = lib.mkOption {
              type = with lib.types; listOf (attrsOf port);
              default = [
                {
                  from = 6881;
                  to = 6999;
                }
              ];
              description = "Set UDP listening port range used by DHT(IPv4, IPv6) and UDP tracker.";
            };
            rpc-listen-port = lib.mkOption {
              type = lib.types.port;
              default = defaultRpcListenPort;
              description = "Specify a port number for JSON-RPC/XML-RPC server to listen to. Possible Values: 1024-65535";
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.settings.enable-rpc;
        message = "RPC has to be enabled, the default module option takes care of that.";
      }
      {
        assertion = !(cfg.settings ? rpc-secret);
        message = "Set the RPC secret through services.aria2.rpcSecretFile so it will not end up in the world-readable nix store.";
      }
    ];

    # Need to open ports for proper functioning
    networking.firewall = lib.mkIf cfg.openPorts {
      allowedUDPPortRanges = config.services.aria2.settings.listen-port;
      allowedTCPPorts = [ config.services.aria2.settings.rpc-listen-port ];
    };

    users.users.aria2 = {
      group = "aria2";
      uid = config.ids.uids.aria2;
      description = "aria2 user";
      home = homeDir;
      createHome = false;
    };

    users.groups.aria2.gid = config.ids.gids.aria2;

    systemd.tmpfiles.rules = [
      "d '${homeDir}' 0770 aria2 aria2 - -"
      "d '${config.services.aria2.settings.dir}' 0770 aria2 aria2 - -"
    ];

    systemd.services.aria2 = {
      description = "aria2 Service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        if [[ ! -e "${cfg.settings.save-session}" ]]
        then
          touch "${cfg.settings.save-session}"
        fi
        cp -f "${pkgs.writeText "aria2.conf" (customToKeyValue cfg.settings)}" "${cfg.settings.conf-path}"
        chmod +w "${cfg.settings.conf-path}"
        echo "rpc-secret=$(cat "$CREDENTIALS_DIRECTORY/rpcSecretFile")" >> "${cfg.settings.conf-path}"
      '';

      serviceConfig = {
        Restart = "on-abort";
        ExecStart = "${pkgs.aria2}/bin/aria2c --conf-path=${cfg.settings.conf-path}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        User = "aria2";
        Group = "aria2";
        LoadCredential = "rpcSecretFile:${cfg.rpcSecretFile}";
      };
    };
  };

  meta.maintainers = [ lib.maintainers.timhae ];
}
