# NixOS module for hans, ip over icmp daemon

{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.hans;

  hansUser = "hans";

in
{

  ### configuration

  options = {

    services.hans = {
      clients = mkOption {
        default = { };
        description = ''
          Each attribute of this option defines a systemd service that
          runs hans. Many or none may be defined.
          The name of each service is
          `hans-«name»`
          where «name» is the name of the
          corresponding attribute name.
        '';
        example = literalExpression ''
          {
            foo = {
              server = "192.0.2.1";
              extraConfig = "-v";
            }
          }
        '';
        type = types.attrsOf (
          types.submodule ({
            options = {
              server = mkOption {
                type = types.str;
                default = "";
                description = "IP address of server running hans";
                example = "192.0.2.1";
              };

              extraConfig = mkOption {
                type = types.str;
                default = "";
                description = "Additional command line parameters";
                example = "-v";
              };

              passwordFile = mkOption {
                type = types.str;
                default = "";
                description = "File that contains password";
              };

            };
          })
        );
      };

      server = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "enable hans server";
        };

        ip = mkOption {
          type = types.str;
          default = "";
          description = "The assigned ip range";
          example = "198.51.100.0";
        };

        respondToSystemPings = mkOption {
          type = types.bool;
          default = false;
          description = "Force hans respond to ordinary pings";
        };

        extraConfig = mkOption {
          type = types.str;
          default = "";
          description = "Additional command line parameters";
          example = "-v";
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

  config = mkIf (cfg.server.enable || cfg.clients != { }) {
    boot.kernel.sysctl = optionalAttrs cfg.server.respondToSystemPings {
      "net.ipv4.icmp_echo_ignore_all" = 1;
    };

    boot.kernelModules = [ "tun" ];

    systemd.services =
      let
        createHansClientService = name: cfg: {
          description = "hans client - ${name}";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          script = "${pkgs.hans}/bin/hans -f -u ${hansUser} ${cfg.extraConfig} -c ${cfg.server} ${
            optionalString (cfg.passwordFile != "") "-p $(cat \"${cfg.passwordFile}\")"
          }";
          serviceConfig = {
            RestartSec = "30s";
            Restart = "always";
          };
        };
      in
      listToAttrs (
        mapAttrsToList (
          name: value: nameValuePair "hans-${name}" (createHansClientService name value)
        ) cfg.clients
      )
      // {
        hans = mkIf (cfg.server.enable) {
          description = "hans, ip over icmp server daemon";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          script = "${pkgs.hans}/bin/hans -f -u ${hansUser} ${cfg.server.extraConfig} -s ${cfg.server.ip} ${optionalString cfg.server.respondToSystemPings "-r"} ${
            optionalString (cfg.server.passwordFile != "") "-p $(cat \"${cfg.server.passwordFile}\")"
          }";
        };
      };

    users.users.${hansUser} = {
      description = "Hans daemon user";
      isSystemUser = true;
    };
  };

  meta.maintainers = with maintainers; [ ];
}
