{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.services.mautrix-whatsapp;
in
{
  options.services.mautrix-whatsapp = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable mautrix-whatsapp, a puppeting bridge between Matrix and WhatsApp.

        See <link xlink:href="https://github.com/tulir/mautrix-whatsapp/wiki/Bridge-setup">here</link> for documentation.
     '';
    };

    config = mkOption {
      type = types.lines;
      description = "YAML configuration file for the bridge";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.mautrix-whatsapp = {
      description = "Mautrix-WhatsApp Service - A WhatsApp bridge for Matrix";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = "mautrix-whatsapp";
        WorkingDirectory = /var/lib/mautrix-whatsapp;
        ExecStart = "${pkg.mautrix-whatsapp}/bin/mautrix-whatsapp -c ${pkgs.writeText "mwa-config.yaml" cfg.config}";
        Restart = "on-failure";
      };

      users.users.mautrix-whatsapp = {
        uid = config.ids.uids.mautrix-whatsapp;
        description = "User for bridge Matrix<->WhatsApp";
        home = /var/lib/mautrix-whatsapp;
        createHome = true;
      };
    };
  };
}
