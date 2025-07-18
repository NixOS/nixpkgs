{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.services.cockpit;
  inherit (lib)
    types
    mkEnableOption
    mkOption
    mkIf
    mkPackageOption
    ;
  settingsFormat = pkgs.formats.ini { };
in
{
  options = {
    services.cockpit = {
      enable = mkEnableOption "Cockpit";

      package = mkPackageOption pkgs "Cockpit" {
        default = [ "cockpit" ];
      };

      allowed-origins = lib.mkOption {
        type = types.listOf types.str;

        default = [ ];

        description = ''
          List of allowed origins.

          Maps to the WebService.Origins setting and allows merging from multiple modules.
        '';
      };

      settings = lib.mkOption {
        type = settingsFormat.type;

        default = { };

        description = ''
          Settings for cockpit that will be saved in /etc/cockpit/cockpit.conf.

          See the [documentation](https://cockpit-project.org/guide/latest/cockpit.conf.5.html), that is also available with `man cockpit.conf.5` for details.
        '';
      };

      port = mkOption {
        description = "Port where cockpit will listen.";
        type = types.port;
        default = 9090;
      };

      openFirewall = mkOption {
        description = "Open port for cockpit.";
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf cfg.enable {

    # expose cockpit-bridge system-wide
    environment.systemPackages = [ cfg.package ];

    # allow cockpit to find its plugins
    environment.pathsToLink = [ "/share/cockpit" ];

    # generate cockpit settings
    environment.etc."cockpit/cockpit.conf".source = settingsFormat.generate "cockpit.conf" cfg.settings;

    security.pam.services.cockpit = {
      startSession = true;
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

    systemd.packages = [ cfg.package ];
    systemd.sockets.cockpit.wantedBy = [ "multi-user.target" ];
    systemd.sockets.cockpit.listenStreams = [
      "" # workaround so it doesn't listen on both ports caused by the runtime merging
      (toString cfg.port)
    ];

    systemd.tmpfiles.rules = [
      # From $out/lib/tmpfiles.d/cockpit-tmpfiles.conf
      "C /run/cockpit/inactive.motd 0640 root root - ${cfg.package}/share/cockpit/motd/inactive.motd"
      "f /run/cockpit/active.motd   0640 root root -"
      "L+ /run/cockpit/motd - - - - inactive.motd"
      "d /etc/cockpit/ws-certs.d 0600 root root 0"
    ];

    services.cockpit.allowed-origins = [
      "https://localhost:${toString config.services.cockpit.port}"
    ];

    services.cockpit.settings.WebService.Origins =
      builtins.concatStringsSep " " config.services.cockpit.allowed-origins;
  };

  meta.maintainers = pkgs.cockpit.meta.maintainers;
}
