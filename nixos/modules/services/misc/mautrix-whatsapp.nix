{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.services.mautrix-whatsapp;
in
{
  options.services.mautrix-whatsapp = {
    enable = mkEnableOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable mautrix-whatsapp, a puppeting bridge between Matrix and WhatsApp.

        See <link xlink:href="https://github.com/tulir/mautrix-whatsapp/wiki/Bridge-setup">here</link> for documentation.
     '';
    };

    config = mkOption {
      type = types.attrs;
      description = "This JSON will be transform in YAML configuration file for the bridge";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.mautrix-whatsapp = {
      description = "Mautrix-WhatsApp Service - A WhatsApp bridge for Matrix";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "mautrix-whatsapp";
        ExecStart = "${pkgs.mautrix-whatsapp}/bin/mautrix-whatsapp -c ${pkgs.writeText "mwa-config.yaml" cfg.config}";
        Restart = "on-failure";
      };
    };
  };
}
