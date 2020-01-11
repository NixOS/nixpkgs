# NixOS module for iodine, ip over dns daemon

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.iodine;

  iodinedUser = "iodined";

in
{
  imports = [
    (mkRenamedOptionModule [ "services" "iodined" "enable" ] [ "services" "iodine" "server" "enable" ])
    (mkRenamedOptionModule [ "services" "iodined" "domain" ] [ "services" "iodine" "server" "domain" ])
    (mkRenamedOptionModule [ "services" "iodined" "ip" ] [ "services" "iodine" "server" "ip" ])
    (mkRenamedOptionModule [ "services" "iodined" "extraConfig" ] [ "services" "iodine" "server" "extraConfig" ])
    (mkRemovedOptionModule [ "services" "iodined" "client" ] "")
  ];

  ### configuration

  options = {

    services.iodine = {
      clients = mkOption {
        default = {};
        description = ''
          Each attribute of this option defines a systemd service that
          runs iodine. Many or none may be defined.
          The name of each service is
          <literal>iodine-<replaceable>name</replaceable></literal>
          where <replaceable>name</replaceable> is the name of the
          corresponding attribute name.
        '';
        example = literalExample ''
        {
          foo = {
            server = "tunnel.mdomain.com";
            relay = "8.8.8.8";
            extraConfig = "-v";
          }
        }
        '';
        type = types.attrsOf (types.submodule (
        {
          options = {
            server = mkOption {
              type = types.str;
              default = "";
              description = "Domain or Subdomain of server running iodined";
              example = "tunnel.mydomain.com";
            };

            relay = mkOption {
              type = types.str;
              default = "";
              description = "DNS server to use as a intermediate relay to the iodined server";
              example = "8.8.8.8";
            };

            extraConfig = mkOption {
              type = types.str;
              default = "";
              description = "Additional command line parameters";
              example = "-l 192.168.1.10 -p 23";
            };

            passwordFile = mkOption {
              type = types.str;
              default = "";
              description = "File that contains password";
            };
          };
        }));
      };

      server = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "enable iodined server";
        };

        ip = mkOption {
          type = types.str;
          default = "";
          description = "The assigned ip address or ip range";
          example = "172.16.10.1/24";
        };

        domain = mkOption {
          type = types.str;
          default = "";
          description = "Domain or subdomain of which nameservers point to us";
          example = "tunnel.mydomain.com";
        };

        extraConfig = mkOption {
          type = types.str;
          default = "";
          description = "Additional command line parameters";
          example = "-l 192.168.1.10 -p 23";
        };

        passwordFile = mkOption {
          type = types.str;
          default = "";
          description = "File that contains password";
        };
      };

    };
  };

  ### implementation

  config = mkIf (cfg.server.enable || cfg.clients != {}) {
    environment.systemPackages = [ pkgs.iodine ];
    boot.kernelModules = [ "tun" ];

    systemd.services =
    let
      createIodineClientService = name: cfg:
      {
        description = "iodine client - ${name}";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        script = "exec ${pkgs.iodine}/bin/iodine -f -u ${iodinedUser} ${cfg.extraConfig} ${optionalString (cfg.passwordFile != "") "< \"${cfg.passwordFile}\""} ${cfg.relay} ${cfg.server}";
        serviceConfig = {
          RestartSec = "30s";
          Restart = "always";
        };
      };
    in
    listToAttrs (
      mapAttrsToList
        (name: value: nameValuePair "iodine-${name}" (createIodineClientService name value))
        cfg.clients
    ) // {
      iodined = mkIf (cfg.server.enable) {
        description = "iodine, ip over dns server daemon";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        script = "exec ${pkgs.iodine}/bin/iodined -f -u ${iodinedUser} ${cfg.server.extraConfig} ${optionalString (cfg.server.passwordFile != "") "< \"${cfg.server.passwordFile}\""} ${cfg.server.ip} ${cfg.server.domain}";
      };
    };

    users.users.${iodinedUser} = {
      uid = config.ids.uids.iodined;
      description = "Iodine daemon user";
    };
    users.groups.iodined.gid = config.ids.gids.iodined;
  };
}
