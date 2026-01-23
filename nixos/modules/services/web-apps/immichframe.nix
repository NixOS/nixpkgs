{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.immichframe;
  format = pkgs.formats.json { };
  inherit (lib)
    types
    mkIf
    mkOption
    mkEnableOption
    ;
in
{
  options.services.immichframe = {
    enable = mkEnableOption "ImmichFrame";
    package = lib.mkPackageOption pkgs "immichframe" { };

    port = mkOption {
      type = types.port;
      default = 3000;
      description = "The port that ImmichFrame will listen on.";
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = format.type;
        options = {
          Accounts = mkOption {
            type = types.listOf (
              types.submodule {
                freeformType = format.type;
                options = {
                  ImmichServerUrl = mkOption {
                    type = types.str;
                    example = "http://photos.example.com";
                    description = "The URL of your Immich server.";
                  };
                  ApiKey = mkOption {
                    type = types.nullOr types.str;
                    default = null;
                    description = ''
                      API key to talk to the Immich server.
                      Warning: it will be world-readable in /nix/store.
                      Consider using {option}`ApiKeyFile` instead.

                      See
                      <https://immichframe.online/docs/getting-started/configuration#api-key-permissions>
                      for details on what permissions this key needs.
                    '';
                  };
                  ApiKeyFile = mkOption {
                    type = types.nullOr types.externalPath;
                    default = null;
                    description = ''
                      File containing an API key to talk to the Immich server.

                      See
                      <https://immichframe.online/docs/getting-started/configuration#api-key-permissions>
                      for details on what permissions this key needs.
                    '';
                  };
                };
              }
            );

            description = ''
              Accounts configuration, multiple are permitted. See
              <https://immichframe.online/docs/getting-started/configuration>.
            '';
          };
        };
      };
      default = { };
      description = ''
        Configuration for ImmichFrame. See
        <https://immichframe.online/docs/getting-started/configuration> for
        options and defaults.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = lib.imap0 (i: account: {
      assertion = lib.xor (account.ApiKey == null) (account.ApiKeyFile == null);
      message = "Exactly one of {option}`services.immichframe.settings.Accounts[${toString i}].ApiKey` and {option}`services.immichframe.settings.Accounts[${toString i}].ApiKeyFile` must be specified";
    }) cfg.settings.Accounts;

    systemd.services.immichframe =
      let
        accountsWithApiKeyFiles = lib.filter (account: account.ApiKeyFile != null) cfg.settings.Accounts;
        apiKeyFileToId = lib.listToAttrs (
          lib.imap0 (
            index: account: lib.nameValuePair account.ApiKeyFile "api-key-${toString index}"
          ) accountsWithApiKeyFiles
        );
        settingsPatchWithCredentialPaths = {
          Accounts = map (
            account:
            account
            // (
              if account.ApiKeyFile != null then
                {
                  ApiKeyFile = "/run/credentials/${config.systemd.services.immichframe.name}/${
                    apiKeyFileToId.${account.ApiKeyFile}
                  }";
                }
              else
                { }
            )
          ) cfg.settings.Accounts;
        };
        settingsWithFixedSecretPaths = lib.recursiveUpdate cfg.settings settingsPatchWithCredentialPaths;
      in
      {
        description = "Display your photos from Immich as a digital photo frame";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        environment = {
          IMMICHFRAME_CONFIG_PATH = pkgs.runCommand "Config" { } ''
            mkdir $out
            ln -s ${format.generate "Settings.json" settingsWithFixedSecretPaths} $out/Settings.json
          '';
        };
        serviceConfig = {
          ExecStart = "${lib.getExe cfg.package} --urls=http://localhost:${toString cfg.port}";
          LoadCredential = lib.concatMapAttrsStringSep ":" (
            apiKeyFile: id: "${id}:${apiKeyFile}"
          ) apiKeyFileToId;
          DynamicUser = true;
          Type = "simple";
          Restart = "on-failure";
          RestartSec = 3;
        };
      };
  };

  meta.maintainers = with lib.maintainers; [ jfly ];
}
