{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.packet;
in
{
  options = {
    programs.packet = {
      enable = lib.mkEnableOption "packet, a Quick Share client for Linux";

      package = lib.mkPackageOption pkgs "packet" { };

      port = lib.mkOption {
        type = lib.types.oneOf [
          lib.types.port
          (lib.types.enum [ "dynamic" ])
        ];
        default = 9300;
        description = ''
          The port used by packet. Setting to `"dynamic"` will disable
          static network port, and will not work with {option}`programs.packet.openFirewall`.
        '';
      };

      openFirewall = lib.mkEnableOption "open firewall port for packet" // {
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.openFirewall -> (cfg.port != "dynamic");
        message = "Cannot open firewall for packet with dynamic port.";
      }
    ];

    environment.systemPackages = [ cfg.package ];

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    programs.dconf.profiles.user.databases = [
      {
        settings."io/github/nozwock/Packet" = {
          enable-static-port = cfg.port != "dynamic";
        }
        // (lib.optionalAttrs (cfg.port != "dynamic") {
          static-port-number = lib.gvariant.mkInt32 cfg.port;
        });
      }
    ];
  };

  meta.maintainers = with lib.maintainers; [ aleksana ];
}
