{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.services.mautrix-whatsapp;
  configFile = pkgs.runCommand "config.yaml" {
    buildInputs = [ pkgs.remarshal ];
    preferLocalBuild = true;
  } ''
    remarshal -if json -of yaml \
      < ${pkgs.writeText "config.json" (builtins.toJSON cfg.configOptions)} \
      > $out
  '';

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

    configOptions = mkOption {
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
        ExecStart = ''
          ${pkgs.mautrix-whatsapp}/bin/mautrix-whatsapp -c "${configFile}"
        '';
        Restart = "on-failure";
      };
    };
  };
}
