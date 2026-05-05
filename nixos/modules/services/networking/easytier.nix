{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.easytier;
  activeInsts = lib.filterAttrs (_: inst: inst.enable) cfg.instances;
in
{
  options.services.easytier = {
    enable = lib.mkEnableOption "EasyTier daemon";

    package = lib.mkPackageOption pkgs "easytier" { };

    allowSystemForward = lib.mkEnableOption ''
      Allow the system to forward packets from easytier. Useful when
      `proxy_forward_by_system` enabled.
    '';

    instances = lib.mkOption {
      description = ''
        EasyTier instances.
      '';
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Enable the instance.";
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
              };

              settings = lib.mkOption {
                type = lib.types.submodule {
                  options = {
                    instance_name = lib.mkOption {
                      type = lib.types.str;
                      default = name;
                      description = "Identify different instances on same host.";
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
                default = { };
                description = ''
                  Settings to generate the easytier config file.
                '';
              };

              extraSettings = lib.mkOption {
                type = (pkgs.formats.toml { }).type;
                default = { };
                description = ''
                  Extra settings to add to the easytier config file.
                '';
              };

              extraArgs = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                description = ''
                  Extra args appended to the easytier command-line.
                '';
              };
            };
          }
        )
      );
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    system.services = lib.mapAttrs' (
      name: inst:
      lib.nameValuePair "easytier-${name}" {
        imports = [ pkgs.easytier.services.default ];
        easytier = {
          package = cfg.package;
          instanceName = name;
          inherit (inst)
            configServer
            configFile
            environmentFiles
            settings
            extraSettings
            extraArgs
            ;
        };
        # Runtime PATH dependencies (iproute2 for ip commands, bash for scripts)
        systemd.service.path = with pkgs; [
          cfg.package
          iproute2
          bash
        ];
      }
    ) activeInsts;

    boot.kernel.sysctl = lib.mkIf cfg.allowSystemForward {
      "net.ipv4.conf.all.forwarding" = lib.mkOverride 97 true;
      "net.ipv6.conf.all.forwarding" = lib.mkOverride 97 true;
    };
  };

  meta.maintainers = with lib.maintainers; [
    ltrump
  ];
}
