{ systemConfig, lib, pkgs, ... }:
with lib;
types.submodule ({ config, name, ... }:
  let
    inherit (systemConfig.services.matrix-appservices)
      homeserverDomain;

    asFormats = (import ./as-formats.nix) {
      inherit name lib pkgs systemConfig;
      asConfig = config;
    };
    asFormat = asFormats.${config.format};
    settingsFormat = pkgs.formats.json { };
  in
  {
    options = rec {

      format = mkOption {
        type = types.enum (mapAttrsToList (n: _: n) asFormats);
        default = "other";
        description = ''
          Format of the appservice, used to set option defaults for appservice.
          This is usually determined by the library the appservice is based on.

          Below are descriptions for each format

        '' + (concatStringsSep "\n" (mapAttrsToList
          (n: v: "${n}: ${v.description}")
          asFormats));
      };

      package = mkOption {
        type = types.nullOr types.package;
        default = null;
        example = "pkgs.mautrix-whatsapp";
        description = ''
          The package for the appservice. Used by formats except 'other'.
          This is unecessary if startupScript is set.
        '';
      };

      settings = mkOption rec {
        type = settingsFormat.type;
        apply = recursiveUpdate default;
        default = asFormat.settings or { };
        defaultText = "Format will attempt to configure database and allow homeserver users";
        example = literalExpression ''
          {
            bridge = {
              domain = "public-domain.tld";
              homeserverUrl = "http://public-domain.tld:8008";
            };
          }
        '';
        description = ''
          Appservice configuration as a Nix attribute set.
          All environment variables will be substituted.
          Including:
            - $DIR which refers to the appservice's data directory.
            - $AS_TOKEN, $HS_TOKEN which refers to the Appservice and
                Homeserver registration tokens.

          Secret tokens, should be specified in serviceConfig.EnvironmentFile
          instead of this world-readable attribute set.

          Configuration options should match those described as per your appservice's settings
          Check out the confg sample for this.

        '';
      };

      registrationData = mkOption {
        type = settingsFormat.type;
        default = asFormat.registrationData or {
          namespaces = {
            users = [
              {
                regex = "@${name}_.*:${homeserverDomain}";
                exclusive = true;
              }
              {
                regex = "@${name}bot:${homeserverDomain}";
                exclusive = true;
              }
            ];
          };
        };
        defaultText = ''
          Reserve usernames under the homeserver that start with
          this appservice's name followed by an _ or "bot"
        '';
        description = ''
          Data to set in the registration file for the appservice. The default
          set or the format should usually deal with this.
        '';
      };

      host = mkOption {
        type = types.str;
        default = "localhost";
        description = ''
          The host the appservice will listen on.
          Will need to specified in config, but most formats will do it for you using
          this option.
        '';
      };

      port = mkOption {
        type = types.port;
        description = ''
          The port the appservice will listen on.
          Will need to specified in config, but most formats will do it for you using
          this option.
        '';
      };

      startupScript = mkOption {
        type = types.str;
        default = asFormat.startupScript or "";
        description = ''
          Script that starts the appservice.
          The settings file will be available as $SETTINGS_FILE
          and the registration file as $REGISTRATION_FILE
        '';
      };

      serviceConfig = mkOption rec {
        type = types.attrs;
        apply = x: default // x;
        default = asFormat.serviceConfig or { };
        description = ''
          Overrides for settings in the service's serviceConfig
        '';
      };

      serviceDependencies = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          Services started before this appservice
        '';
      };
    };
  })
