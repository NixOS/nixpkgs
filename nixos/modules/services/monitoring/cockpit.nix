{ pkgs, config, lib, ... }:

let
  cfg = config.services.cockpit;
  settingsFormat = pkgs.formats.ini {};
in {
  options = {
    services.cockpit = {
      enable = lib.mkEnableOption "Cockpit";

      package = lib.mkPackageOption pkgs "Cockpit" {
        default = [ "cockpit" ];
      };

      settings = lib.mkOption {
        type = settingsFormat.type;

        default = {};

        description = ''
          Settings for cockpit that will be saved in /etc/cockpit/cockpit.conf.

          See the [documentation](https://cockpit-project.org/guide/latest/cockpit.conf.5.html), that is also available with `man cockpit.conf.5` for details.
        '';
      };

      port = lib.mkOption {
        description = "Port where cockpit will listen.";
        type = lib.types.port;
        default = 9090;
      };

      openFirewall = lib.mkOption {
        description = "Open port for cockpit.";
        type = lib.types.bool;
        default = false;
      };
    };
  };
  config = lib.mkIf cfg.enable {

    # expose cockpit-bridge system-wide
    environment.systemPackages = [ cfg.package ];

    # allow cockpit to find its plugins
    environment.pathsToLink = [ "/share/cockpit" ];

    # generate cockpit settings
    environment.etc."cockpit/cockpit.conf".source = settingsFormat.generate "cockpit.conf" cfg.settings;

    security.pam.services.cockpit = {};

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

    systemd.packages = [ cfg.package ];
    systemd.sockets.cockpit.wantedBy = [ "multi-user.target" ];

    systemd.tmpfiles.rules = [ # From $out/lib/tmpfiles.d/cockpit-tmpfiles.conf
      "C /run/cockpit/inactive.motd 0640 root root - ${cfg.package}/share/cockpit/motd/inactive.motd"
      "f /run/cockpit/active.motd   0640 root root -"
      "L+ /run/cockpit/motd - - - - inactive.motd"
      "d /etc/cockpit/ws-certs.d 0600 root root 0"
    ];
  };

  meta.maintainers = pkgs.cockpit.meta.maintainers;
}
