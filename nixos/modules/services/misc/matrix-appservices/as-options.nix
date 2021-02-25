{ systemConfig, lib, pkgs, ... }:
with lib;
types.submodule ({ config, ... }:
  let
    asFormats = (import ./as-formats.nix) {
      inherit lib pkgs systemConfig;
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
          This is unecessary if startupScript and registerScript is set.
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
          All environment variables will be substituted,
          including $DIR which refers to the appservice's data directory.

          Secret tokens, should be specified in serviceConfig.EnvironmentFile
          instead of this world-readable attribute set.

          Configuration options should match those described as per your appservice's settings
          Check out the confg sample for this.

        '';
      };

      preStart = mkOption {
        type = types.str;
        default = asFormat.preStart or "";
        description = ''
          Script that is run right before registration and startup.
          The settings file will be available as $SETTINGS_FILE
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

      registerScript = mkOption {
        type = types.str;
        default = asFormat.registerScript or "";
        description = ''
          Script that registers the appservice using the settings.
          The settings file will be available as $SETTINGS_FILE
          and the registration file must be saved to $REGISTRATION_FILE
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
