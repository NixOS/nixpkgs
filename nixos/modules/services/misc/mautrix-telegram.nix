{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.services.mautrix-telegram;

  configFile = pkgs.runCommand "mautrix-telegram" {
    buildInputs = [ pkgs.mautrix-telegram pkgs.remarshal ];
    preferLocalBuild = true;
  } ''
    mkdir -p $out
    remarshal -if json -of yaml \
      < ${pkgs.writeText "config.json" (builtins.toJSON cfg.configOptions)} \
      > $out/config.yaml

    ${pkgs.mautrix-telegram}/bin/mautrix-telegram -c $out/config.yaml -g -r $out/registration.yaml
  '';

in
{
  options.services.mautrix-telegram = {
    enable = mkEnableOption "Mautrix-telegram, a bridge between Matrix and Telegram";

    configOptions = mkOption {
      type = types.attrs;
      description = ''
        This options will be transform in YAML configuration file for the bridge

        Look at the <link xlink:href="https://github.com/tulir/mautrix-telegram/wiki/Bridge-setup">documentation</link> for more details.
        You will found the list of options <link xlink:href="https://github.com/tulir/mautrix-telegram/blob/master/example-config.yaml">here</link>
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.mautrix-telegram = {
      description = "Mautrix-Telegram Service - A Telegram bridge for Matrix";
      after = [ "network.target" "matrix-synapse.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "mautrix-telegram";
        preStart = ''
          ${pkgs.mautrix-telegram.alembic}/bin/alembic -x config=${configFile}/config.yaml upgrade head
        '';
        ExecStart = ''
          ${pkgs.mautrix-telegram}/bin/mautrix-telegram -c "${configFile}/config.yaml"
        '';
        Restart = "on-failure";
      };
    };

    services.matrix-synapse.app_service_config_files = [ "${configFile}/registration.yaml" ];

  };
}
