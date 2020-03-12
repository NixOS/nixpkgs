{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.services.paperless;

  defaultUser = "paperless";

  manage = cfg.package.withConfig {
    config = {
      PAPERLESS_CONSUMPTION_DIR = cfg.consumptionDir;
      PAPERLESS_INLINE_DOC = "true";
      PAPERLESS_DISABLE_LOGIN = "true";
    } // cfg.extraConfig;
    inherit (cfg) dataDir ocrLanguages;
    paperlessPkg = cfg.package;
  };
in
{
  options.services.paperless = {
    enable = mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable Paperless.

        When started, the Paperless database is automatically created if it doesn't
        exist and updated if the Paperless package has changed.
        Both tasks are achieved by running a Django migration.
      '';
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/paperless";
      description = "Directory to store the Paperless data.";
    };

    consumptionDir = mkOption {
      type = types.str;
      default = "${cfg.dataDir}/consume";
      defaultText = "\${dataDir}/consume";
      description = "Directory from which new documents are imported.";
    };

    consumptionDirIsPublic = mkOption {
      type = types.bool;
      default = false;
      description = "Whether all users can write to the consumption dir.";
    };

    ocrLanguages = mkOption {
      type = with types; nullOr (listOf str);
      default = null;
      description = ''
        Languages available for OCR via Tesseract, specified as
        <literal>ISO 639-2/T</literal> language codes.
        If unset, defaults to all available languages.
      '';
      example = [ "eng" "spa" "jpn" ];
    };

    address = mkOption {
      type = types.str;
      default = "localhost";
      description = "Server listening address.";
    };

    port = mkOption {
      type = types.int;
      default = 28981;
      description = "Server port to listen on.";
    };

    extraConfig = mkOption {
      type = types.attrs;
      default = {};
      description = ''
        Extra paperless config options.

        The config values are evaluated as double-quoted Bash string literals.

        See <literal>paperless-src/paperless.conf.example</literal> for available options.

        To enable user authentication, set <literal>PAPERLESS_DISABLE_LOGIN = "false"</literal>
        and run the shell command <literal>$dataDir/paperless-manage createsuperuser</literal>.

        To define secret options without storing them in /nix/store, use the following pattern:
        <literal>PAPERLESS_PASSPHRASE = "$(&lt; /etc/my_passphrase_file)"</literal>
      '';
      example = literalExample ''
        {
          PAPERLESS_OCR_LANGUAGE = "deu";
        }
      '';
    };

    user = mkOption {
      type = types.str;
      default = defaultUser;
      description = "User under which Paperless runs.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.paperless;
      defaultText = "pkgs.paperless";
      description = "The Paperless package to use.";
    };

    manage = mkOption {
      type = types.package;
      readOnly = true;
      default = manage;
      description = ''
        A script to manage the Paperless instance.
        It wraps Django's manage.py and is also available at
        <literal>$dataDir/manage-paperless</literal>
      '';
    };
  };

  config = mkIf cfg.enable {

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' - ${cfg.user} ${config.users.users.${cfg.user}.group} - -"
    ] ++ (optional cfg.consumptionDirIsPublic
      "d '${cfg.consumptionDir}' 777 - - - -"
      # If the consumption dir is not created here, it's automatically created by
      # 'manage' with the default permissions.
    );

    systemd.services.paperless-consumer = {
      description = "Paperless document consumer";
      serviceConfig = {
        User = cfg.user;
        ExecStart = "${manage} document_consumer";
        Restart = "always";
      };
      after = [ "systemd-tmpfiles-setup.service" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        if [[ $(readlink ${cfg.dataDir}/paperless-manage) != ${manage} ]]; then
          ln -sf ${manage} ${cfg.dataDir}/paperless-manage
        fi

        ${manage.setupEnv}
        # Auto-migrate on first run or if the package has changed
        versionFile="$PAPERLESS_DBDIR/src-version"
        if [[ $(cat "$versionFile" 2>/dev/null) != ${cfg.package} ]]; then
          python $paperlessSrc/manage.py migrate
          echo ${cfg.package} > "$versionFile"
        fi
      '';
    };

    systemd.services.paperless-server = {
      description = "Paperless document server";
      serviceConfig = {
        User = cfg.user;
        ExecStart = "${manage} runserver --noreload ${cfg.address}:${toString cfg.port}";
        Restart = "always";
      };
      # Bind to `paperless-consumer` so that the server never runs
      # during migrations
      bindsTo = [ "paperless-consumer.service" ];
      after = [ "paperless-consumer.service" ];
      wantedBy = [ "multi-user.target" ];
    };

    users = optionalAttrs (cfg.user == defaultUser) {
      users.${defaultUser} = {
        group = defaultUser;
        uid = config.ids.uids.paperless;
        home = cfg.dataDir;
      };

      groups.${defaultUser} = {
        gid = config.ids.gids.paperless;
      };
    };
  };
}
