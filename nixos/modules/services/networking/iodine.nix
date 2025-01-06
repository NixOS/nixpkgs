# NixOS module for iodine, ip over dns daemon
{ config, lib, pkgs, ... }:
let
  cfg = config.services.iodine;

  iodinedUser = "iodined";

  /* is this path made unreadable by ProtectHome = true ? */
  isProtected = x: lib.hasPrefix "/root" x || lib.hasPrefix "/home" x;
in
{
  imports = [
    (lib.mkRenamedOptionModule [ "services" "iodined" "enable" ] [ "services" "iodine" "server" "enable" ])
    (lib.mkRenamedOptionModule [ "services" "iodined" "domain" ] [ "services" "iodine" "server" "domain" ])
    (lib.mkRenamedOptionModule [ "services" "iodined" "ip" ] [ "services" "iodine" "server" "ip" ])
    (lib.mkRenamedOptionModule [ "services" "iodined" "extraConfig" ] [ "services" "iodine" "server" "extraConfig" ])
    (lib.mkRemovedOptionModule [ "services" "iodined" "client" ] "")
  ];

  ### configuration

  options = {

    services.iodine = {
      clients = lib.mkOption {
        default = {};
        description = ''
          Each attribute of this option defines a systemd service that
          runs iodine. Many or none may be defined.
          The name of each service is
          `iodine-«name»`
          where «name» is the name of the
          corresponding attribute name.
        '';
        example = lib.literalExpression ''
          {
            foo = {
              server = "tunnel.mdomain.com";
              relay = "8.8.8.8";
              extraConfig = "-v";
            }
          }
        '';
        type = lib.types.attrsOf (
          lib.types.submodule (
            {
              options = {
                server = lib.mkOption {
                  type = lib.types.str;
                  default = "";
                  description = "Hostname of server running iodined";
                  example = "tunnel.mydomain.com";
                };

                relay = lib.mkOption {
                  type = lib.types.str;
                  default = "";
                  description = "DNS server to use as an intermediate relay to the iodined server";
                  example = "8.8.8.8";
                };

                extraConfig = lib.mkOption {
                  type = lib.types.str;
                  default = "";
                  description = "Additional command line parameters";
                  example = "-l 192.168.1.10 -p 23";
                };

                passwordFile = lib.mkOption {
                  type = lib.types.str;
                  default = "";
                  description = "Path to a file containing the password.";
                };
              };
            }
          )
        );
      };

      server = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "enable iodined server";
        };

        ip = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "The assigned ip address or ip range";
          example = "172.16.10.1/24";
        };

        domain = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Domain or subdomain of which nameservers point to us";
          example = "tunnel.mydomain.com";
        };

        extraConfig = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Additional command line parameters";
          example = "-l 192.168.1.10 -p 23";
        };

        passwordFile = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "File that contains password";
        };
      };

    };
  };

  ### implementation

  config = lib.mkIf (cfg.server.enable || cfg.clients != {}) {
    environment.systemPackages = [ pkgs.iodine ];
    boot.kernelModules = [ "tun" ];

    systemd.services =
      let
        createIodineClientService = name: cfg:
          {
            description = "iodine client - ${name}";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            script = "exec ${pkgs.iodine}/bin/iodine -f -u ${iodinedUser} ${cfg.extraConfig} ${lib.optionalString (cfg.passwordFile != "") "< \"${builtins.toString cfg.passwordFile}\""} ${cfg.relay} ${cfg.server}";
            serviceConfig = {
              RestartSec = "30s";
              Restart = "always";

              # hardening :
              # Filesystem access
              ProtectSystem = "strict";
              ProtectHome = if isProtected cfg.passwordFile then "read-only" else "true" ;
              PrivateTmp = true;
              ReadWritePaths = "/dev/net/tun";
              PrivateDevices = false;
              ProtectKernelTunables = true;
              ProtectKernelModules = true;
              ProtectControlGroups = true;
              # Caps
              NoNewPrivileges = true;
              # Misc.
              LockPersonality = true;
              RestrictRealtime = true;
              PrivateMounts = true;
              MemoryDenyWriteExecute = true;
            };
          };
      in
        lib.listToAttrs (
          lib.mapAttrsToList
            (name: value: lib.nameValuePair "iodine-${name}" (createIodineClientService name value))
            cfg.clients
        ) // {
          iodined = lib.mkIf (cfg.server.enable) {
            description = "iodine, ip over dns server daemon";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            script = "exec ${pkgs.iodine}/bin/iodined -f -u ${iodinedUser} ${cfg.server.extraConfig} ${lib.optionalString (cfg.server.passwordFile != "") "< \"${builtins.toString cfg.server.passwordFile}\""} ${cfg.server.ip} ${cfg.server.domain}";
            serviceConfig = {
              # Filesystem access
              ProtectSystem = "strict";
              ProtectHome = if isProtected cfg.server.passwordFile then "read-only" else "true" ;
              PrivateTmp = true;
              ReadWritePaths = "/dev/net/tun";
              PrivateDevices = false;
              ProtectKernelTunables = true;
              ProtectKernelModules = true;
              ProtectControlGroups = true;
              # Caps
              NoNewPrivileges = true;
              # Misc.
              LockPersonality = true;
              RestrictRealtime = true;
              PrivateMounts = true;
              MemoryDenyWriteExecute = true;
            };
          };
        };

    users.users.${iodinedUser} = {
      uid = config.ids.uids.iodined;
      group = "iodined";
      description = "Iodine daemon user";
    };
    users.groups.iodined.gid = config.ids.gids.iodined;
  };
}
