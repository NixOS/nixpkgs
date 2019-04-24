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
    enable = mkEnableOption "Mautrix-whatsapp, a puppeting bridge between Matrix and WhatsApp.";

    configOptions = mkOption {
      type = types.attrs;
      description = ''
        This options will be transform in YAML configuration file for the bridge

        Look <link xlink:href="https://github.com/tulir/mautrix-whatsapp/wiki/Bridge-setup">here</link> for documentation.
      '';
      example = ''
        configOptions = {
          homeserver = {
            address = https://matrix.org;
            domain = "matrix.org";
          };
          appservice = {
            address = http://localhost:8080;
            hostname = "0.0.0.0";
            port = 8080;
            database = {
              type = "sqlite3";
              uri = "/var/lib/mautrix-whatsapp/mautrix-whatsapp.db";
            };
            state_store_path = "/var/lib/mautrix-whatsapp/mx-state.json";
            id = "whatsapp";
            bot = {
              username = "whatsappbot";
              displayname = "WhatsApp bridge bot";
              avatar = "mxc://maunium.net/NeXNQarUbrlYBiPCpprYsRqr";
            };
            as_token = "";
            hs_token = "";
          };
          bridge = {
            username_template = "whatsapp_{{.}}";
            displayname_template = "{{if .Notify}}{{.Notify}}{{else}}{{.Jid}}{{end}} (WA)";
            command_prefix = "!wa";
            permissions = {
              "@example:matrix.org" = 100;
            };
          };
          logging = {
            directory = "/var/lib/mautrix-whatsapp/logs";
            file_name_format = "{{.Date}}-{{.Index}}.log";
            file_date_format = "\"2006-01-02\"";
            file_mode = 384;
            timestamp_format = "Jan _2, 2006 15:04:05";
            print_level = "debug";
          };
        };
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

    services.matrix-synapse.app_service_config_files = [ "${configFile}/registration.yaml" ];

  };
}
