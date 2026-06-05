{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.services.easytier;
  settingsFormat = pkgs.formats.toml { };

  genFinalSettings =
    inst:
    attrsets.filterAttrsRecursive (_: v: v != { }) (
      attrsets.filterAttrsRecursive (_: v: v != null) (
        {
          inherit (inst.settings)
            instance_name
            hostname
            ipv4
            dhcp
            listeners
            ;
          network_identity = {
            inherit (inst.settings) network_name network_secret;
          };
          peer = map (p: { uri = p; }) inst.settings.peers;
        }
        // inst.extraSettings
      )
    );

  genConfigFile =
    name: inst:
    if inst.configFile == null then
      settingsFormat.generate "easytier-${name}.toml" (genFinalSettings inst)
    else
      inst.configFile;

  activeInsts = filterAttrs (_: inst: inst.enable) cfg.instances;

  settingsModule = name: {
    options = {
      instance_name = mkOption {
        type = types.str;
        default = name;
        description = "Identify different instances on same host";
      };

      hostname = mkOption {
        type = with types; nullOr str;
        default = null;
        description = "Hostname shown in peer list and web console.";
      };

      network_name = mkOption {
        type = with types; nullOr str;
        default = null;
        description = "EasyTier network name.";
      };

      network_secret = mkOption {
        type = with types; nullOr str;
        default = null;
        description = ''
          EasyTier network credential used for verification and
          encryption. It can also be set in environmentFile.
        '';
      };

      ipv4 = mkOption {
        type = with types; nullOr str;
        default = null;
        description = ''
          IPv4 cidr address of this peer in the virtual network. If
          empty, this peer will only forward packets and no TUN device
          will be created.
        '';
        example = "10.144.144.1/24";
      };

      dhcp = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Automatically determine the IPv4 address of this peer based on
          existing peers on network.
        '';
      };

      listeners = mkOption {
        type = with types; listOf str;
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

      peers = mkOption {
        type = with types; listOf str;
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

  instanceModule =
    { name, ... }:
    {
      options = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Enable the instance.";
        };

        configServer = mkOption {
          type = with types; nullOr str;
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

        configFile = mkOption {
          type = with types; nullOr path;
          default = null;
          description = ''
            Path to easytier config file. Setting this option will
            override `settings` and `extraSettings` of this instance.
          '';
        };

        environmentFiles = mkOption {
          type = with types; listOf path;
          default = [ ];
          description = ''
            Environment files for this instance. All command-line args
            have corresponding environment variables.
          '';
          example = literalExpression ''
            [
              /path/to/.env
              /path/to/.env.secret
            ]
          '';
        };

        settings = mkOption {
          type = types.submodule (settingsModule name);
          default = { };
          description = ''
            Settings to generate {file}`easytier-${name}.toml`
          '';
        };

        extraSettings = mkOption {
          type = settingsFormat.type;
          default = { };
          description = ''
            Extra settings to add to {file}`easytier-${name}.toml`.
          '';
        };

        extraArgs = mkOption {
          type = with types; listOf str;
          default = [ ];
          description = ''
            Extra args append to the easytier command-line.
          '';
        };
      };
    };

in
{
  options.services.easytier = {
    enable = mkEnableOption "EasyTier daemon";

    package = mkPackageOption pkgs "easytier" { };

    allowSystemForward = mkEnableOption ''
      Allow the system to forward packets from easytier. Useful when
      `proxy_forward_by_system` enabled.
    '';

    instances = mkOption {
      description = ''
        EasyTier instances.
      '';
      type = types.attrsOf (types.submodule instanceModule);
      default = { };
      example = {
        settings = {
          network_name = "easytier";
          network_secret = "easytier";
          ipv4 = "10.144.144.1/24";
          peers = [
            "tcp://public.easytier.cn:11010"
            "wss://example.com:443"
          ];
        };
        extraSettings = {
          flags.dev_name = "tun1";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services = mapAttrs' (
      name: inst:
      let
        configFile = genConfigFile name inst;
      in
      nameValuePair "easytier-${name}" {
        description = "EasyTier Daemon - ${name}";
        wants = [
          "network-online.target"
          "nss-lookup.target"
        ];
        after = [
          "network-online.target"
          "nss-lookup.target"
        ];
        wantedBy = [ "multi-user.target" ];
        path = with pkgs; [
          cfg.package
          iproute2
          bash
        ];
        restartTriggers = inst.environmentFiles ++ (optionals (inst.configServer == null) [ configFile ]);
        serviceConfig = {
          Type = "simple";
          Restart = "on-failure";
          EnvironmentFile = inst.environmentFiles;
          StateDirectory = "easytier/easytier-${name}";
          StateDirectoryMode = "0700";
          WorkingDirectory = "/var/lib/easytier/easytier-${name}";
          ExecStart = escapeShellArgs (
            [
              "${cfg.package}/bin/easytier-core"
            ]
            ++ optionals (inst.configServer != null) (
              [
                "-w"
                "${inst.configServer}"
              ]
              ++ (optionals (inst.settings.hostname != null) [
                "--hostname"
                "${inst.settings.hostname}"
              ])
            )
            ++ optionals (inst.configServer == null) [
              "-c"
              "${configFile}"
            ]
            ++ inst.extraArgs
          );
        };
      }
    ) activeInsts;

    boot.kernel.sysctl = mkIf cfg.allowSystemForward {
      "net.ipv4.conf.all.forwarding" = mkOverride 97 true;
      "net.ipv6.conf.all.forwarding" = mkOverride 97 true;
    };
  };

  meta.maintainers = with maintainers; [
    ltrump
  ];
}
