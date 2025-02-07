# NixOS module for hans, ip over icmp daemon
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.hans;

  hansUser = "hans";

in
{

  ### configuration

  options = {

    services.hans = {
      clients = lib.mkOption {
        default = { };
        description = ''
          Each attribute of this option defines a systemd service that
          runs hans. Many or none may be defined.
          The name of each service is
          `hans-«name»`
          where «name» is the name of the
          corresponding attribute name.
        '';
        example = lib.literalExpression ''
          {
            foo = {
              server = "192.0.2.1";
              extraConfig = "-v";
            }
          }
        '';
        type = lib.types.attrsOf (
          lib.types.submodule ({
            options = {
              server = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = "IP address of server running hans";
                example = "192.0.2.1";
              };

              extraConfig = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = "Additional command line parameters";
                example = "-v";
              };

              passwordFile = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = "File that contains password";
              };

            };
          })
        );
      };

      server = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "enable hans server";
        };

        ip = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "The assigned ip range";
          example = "198.51.100.0";
        };

        respondToSystemPings = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Force hans respond to ordinary pings";
        };

        extraConfig = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Additional command line parameters";
          example = "-v";
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

  config = lib.mkIf (cfg.server.enable || cfg.clients != { }) {
    boot.kernel.sysctl = lib.optionalAttrs cfg.server.respondToSystemPings {
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
            lib.optionalString (cfg.passwordFile != "") "-p $(cat \"${cfg.passwordFile}\")"
          }";
          serviceConfig = {
            RestartSec = "30s";
            Restart = "always";
          };
        };
      in
      lib.listToAttrs (
        lib.mapAttrsToList (
          name: value: lib.nameValuePair "hans-${name}" (createHansClientService name value)
        ) cfg.clients
      )
      // {
        hans = lib.mkIf (cfg.server.enable) {
          description = "hans, ip over icmp server daemon";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          script = "${pkgs.hans}/bin/hans -f -u ${hansUser} ${cfg.server.extraConfig} -s ${cfg.server.ip} ${lib.optionalString cfg.server.respondToSystemPings "-r"} ${
            lib.optionalString (cfg.server.passwordFile != "") "-p $(cat \"${cfg.server.passwordFile}\")"
          }";
        };
      };

    users.users.${hansUser} = {
      description = "Hans daemon user";
      isSystemUser = true;
    };
  };

  meta.maintainers = [ ];
}
