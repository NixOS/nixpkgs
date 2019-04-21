{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.services.mautrix-whatsapp;

  configFile = pkgs.runCommand "mautrix-whatsapp" {
    buildInputs = [ pkgs.mautrix-whatsapp pkgs.remarshal ];
    preferLocalBuild = true;
  } ''
    mkdir -p $out
    remarshal -if json -of yaml \
      < ${pkgs.writeText "config.json" (builtins.toJSON cfg.configOptions)} \
      > $out/config.yaml

    ${pkgs.mautrix-whatsapp}/bin/mautrix-whatsapp -c $out/config.yaml -g -r $out/registration.yaml
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
      description = "This options will be transform in YAML configuration file for the bridge";
    };

    registrationPath = mkOption {
      type = types.path;
      default = "${configFile}/registration.yaml";
      description = ''
        This options will provide a path to the YAML registration file for matrix-synapse.
        The registration.yaml file will be generated in the nix store, so you can refer to it with <literal>config.services.mautrix-whatsapp.registrationPath</literal>. This file must be added in the matrix-synapse service options <literal>services.matrix-synapse.app_service_config_files</literal>

      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.mautrix-whatsapp = {
      description = "Mautrix-WhatsApp Service - A WhatsApp bridge for Matrix";
      after = [ "network.target" "matrix-synapse.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "mautrix-whatsapp";
        ExecStart = ''
          ${pkgs.mautrix-whatsapp}/bin/mautrix-whatsapp -c "${configFile}/config.yaml"
        '';
        Restart = "on-failure";
      };
    };
  };
}
