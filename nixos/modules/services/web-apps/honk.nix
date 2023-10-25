{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.services.honk;

  honk-initdb-script = cfg: pkgs.writeShellApplication {
    name = "honk-initdb-script";

    runtimeInputs = with pkgs; [ coreutils ];

    text = ''
      PW=$(cat "$CREDENTIALS_DIRECTORY/honk_passwordFile")

      echo -e "${cfg.username}\n''$PW\n${cfg.host}:${toString cfg.port}\n${cfg.servername}" | ${lib.getExe cfg.package} -datadir "$STATE_DIRECTORY" init
    '';
  };
in
{
  options = {
    services.honk = {
      enable = lib.mkEnableOption (lib.mdDoc "the Honk server");
      package = lib.mkPackageOptionMD pkgs "honk" { };

      host = lib.mkOption {
        default = "127.0.0.1";
        description = lib.mdDoc ''
          The host name or IP address the server should listen to.
        '';
        type = lib.types.str;
      };

      port = lib.mkOption {
        default = 8080;
        description = lib.mdDoc ''
          The port the server should listen to.
        '';
        type = lib.types.port;
      };

      username = lib.mkOption {
        description = lib.mdDoc ''
          The admin account username.
        '';
        type = lib.types.str;
      };

      passwordFile = lib.mkOption {
        description = lib.mdDoc ''
          Password for admin account.
          NOTE: Should be string not a store path, to prevent the password from being world readable
        '';
        type = lib.types.path;
      };

      servername = lib.mkOption {
        description = lib.mdDoc ''
          The server name.
        '';
        type = lib.types.str;
      };

      extraJS = lib.mkOption {
        default = null;
        description = lib.mdDoc ''
          An extra JavaScript file to be loaded by the client.
        '';
        type = lib.types.nullOr lib.types.path;
      };

      extraCSS = lib.mkOption {
        default = null;
        description = lib.mdDoc ''
          An extra CSS file to be loaded by the client.
        '';
        type = lib.types.nullOr lib.types.path;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.username or "" != "";
        message = ''
          You have to define a username for Honk (`services.honk.username`).
        '';
      }
      {
        assertion = cfg.servername or "" != "";
        message = ''
          You have to define a servername for Honk (`services.honk.servername`).
        '';
      }
    ];

    systemd.services.honk-initdb = {
      description = "Honk server database setup";
      requiredBy = [ "honk.service" ];
      before = [ "honk.service" ];

      serviceConfig = {
        LoadCredential = [
          "honk_passwordFile:${cfg.passwordFile}"
        ];
        Type = "oneshot";
        StateDirectory = "honk";
        DynamicUser = true;
        RemainAfterExit = true;
        ExecStart = lib.getExe (honk-initdb-script cfg);
        PrivateTmp = true;
      };

      unitConfig = {
        ConditionPathExists = [
          # Skip this service if the database already exists
          "!%S/honk/honk.db"
        ];
      };
    };

    systemd.services.honk = {
      description = "Honk server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      bindsTo = [ "honk-initdb.service" ];
      preStart = ''
        mkdir -p $STATE_DIRECTORY/views
        ${lib.optionalString (cfg.extraJS != null) "ln -fs ${cfg.extraJS} $STATE_DIRECTORY/views/local.js"}
        ${lib.optionalString (cfg.extraCSS != null) "ln -fs ${cfg.extraCSS} $STATE_DIRECTORY/views/local.css"}
        ${lib.getExe cfg.package} -datadir $STATE_DIRECTORY -viewdir ${cfg.package}/share/honk backup $STATE_DIRECTORY/backup
        ${lib.getExe cfg.package} -datadir $STATE_DIRECTORY -viewdir ${cfg.package}/share/honk upgrade
        ${lib.getExe cfg.package} -datadir $STATE_DIRECTORY -viewdir ${cfg.package}/share/honk cleanup
      '';
      serviceConfig = {
        ExecStart = ''
          ${lib.getExe cfg.package} -datadir $STATE_DIRECTORY -viewdir ${cfg.package}/share/honk
        '';
        StateDirectory = "honk";
        DynamicUser = true;
        PrivateTmp = "yes";
        Restart = "on-failure";
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ drupol ];
    doc = ./honk.md;
  };
}
