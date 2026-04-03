# Non-module dependencies (`importApply`)
{ settingsFormat }:

# Service module
{
  lib,
  config,
  options,
  name,
  ...
}:

let
  cfg = config.easytier;

  genFinalSettings = lib.attrsets.filterAttrsRecursive (_: v: v != { }) (
    lib.attrsets.filterAttrsRecursive (_: v: v != null) (
      {
        inherit (cfg.settings)
          instance_name
          hostname
          ipv4
          dhcp
          listeners
          ;
        network_identity = {
          inherit (cfg.settings) network_name network_secret;
        };
        peer = map (p: { uri = p; }) cfg.settings.peers;
      }
      // cfg.extraSettings
    )
  );

  configFile =
    if cfg.configFile == null then
      settingsFormat.generate "easytier-${cfg.instanceName}.toml" genFinalSettings
    else
      cfg.configFile;

  settingsModule = {
    options = {
      instance_name = lib.mkOption {
        type = lib.types.str;
        default = name;
        description = "Identify different instances on same host";
      };

      hostname = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Hostname shown in peer list and web console.";
      };

      network_name = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "EasyTier network name.";
      };

      network_secret = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          EasyTier network credential used for verification and
          encryption. It can also be set in environmentFile.
        '';
      };

      ipv4 = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          IPv4 cidr address of this peer in the virtual network. If
          empty, this peer will only forward packets and no TUN device
          will be created.
        '';
        example = "10.144.144.1/24";
      };

      dhcp = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Automatically determine the IPv4 address of this peer based on
          existing peers on network.
        '';
      };

      listeners = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "tcp://0.0.0.0:11010"
          "udp://0.0.0.0:11010"
        ];
        description = ''
          Listener addresses to accept connections from other peers.
          Valid format is: `<proto>://<addr>:<port>`, where the protocol
          can be `tcp`, `udp`, `ring`, `wg`, `ws`, `wss`.
        '';
      };

      peers = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = ''
          Peers to connect initially. Valid format is: `<proto>://<addr>:<port>`.
        '';
        example = [
          "tcp://example.com:11010"
        ];
      };
    };
  };

in
{
  _class = "service";

  options.easytier = {
    package = lib.mkOption {
      description = "The easytier package to use.";
      defaultText = "The easytier package that provided this module.";
      type = lib.types.package;
    };

    instanceName = lib.mkOption {
      type = lib.types.str;
      default = name;
      defaultText = lib.literalExpression "name";
      description = ''
        Instance name used for state directory and config file naming.
        Defaults to the modular service instance name.
      '';
    };

    configServer = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Configure the instance from config server. When this option
        set, any other settings for configuring the instance manually
        except `hostname` will be ignored. Valid formats are:

        - full uri for custom server: `udp://example.com:22020/<token>`
        - username only for official server: `<token>`
      '';
      example = "udp://example.com:22020/myusername";
    };

    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to easytier config file. Setting this option will
        override `settings` and `extraSettings` of this instance.
      '';
    };

    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = ''
        Environment files for this instance. All command-line args
        have corresponding environment variables.
      '';
      example = lib.literalExpression ''
        [
          /path/to/.env
          /path/to/.env.secret
        ]
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule settingsModule;
      default = { };
      description = ''
        Settings to generate {file}`easytier-${name}.toml`
      '';
    };

    extraSettings = lib.mkOption {
      type = settingsFormat.type;
      default = { };
      description = ''
        Extra settings to add to {file}`easytier-${name}.toml`.
      '';
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Extra args append to the easytier command-line.
      '';
    };
  };

  config = {
    process.argv = [
      "${cfg.package}/bin/easytier-core"
    ]
    ++ lib.optionals (cfg.configServer != null) (
      [
        "-w"
        "${cfg.configServer}"
      ]
      ++ (lib.optionals (cfg.settings.hostname != null) [
        "--hostname"
        "${cfg.settings.hostname}"
      ])
    )
    ++ lib.optionals (cfg.configServer == null) [
      "-c"
      "${configFile}"
    ]
    ++ cfg.extraArgs;
  }
  // lib.optionalAttrs (options ? systemd) {
    systemd.service = {
      wants = [
        "network-online.target"
        "nss-lookup.target"
      ];
      after = [
        "network-online.target"
        "nss-lookup.target"
      ];
      restartTriggers = cfg.environmentFiles ++ (lib.optionals (cfg.configServer == null) [ configFile ]);
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        EnvironmentFile = cfg.environmentFiles;
        StateDirectory = "easytier/easytier-${cfg.instanceName}";
        StateDirectoryMode = "0700";
        WorkingDirectory = "/var/lib/easytier/easytier-${cfg.instanceName}";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    ltrump
    kiara
  ];
}
