{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.duplicati;

  parametersFile =
    if cfg.parametersFile != null then
      cfg.parametersFile
    else
      pkgs.writeText "duplicati-parameters" cfg.parameters;
in
{
  options = {
    services.duplicati = {
      enable = lib.mkEnableOption "Duplicati";

      package = lib.mkPackageOption pkgs "duplicati" { };

      port = lib.mkOption {
        default = 8200;
        type = lib.types.port;
        description = ''
          Port serving the web interface
        '';
      };

      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/duplicati";
        description = ''
          The directory where Duplicati stores its data files.

          ::: {.note}
          If left as the default value this directory will automatically be created
          before the Duplicati server starts, otherwise you are responsible for ensuring
          the directory exists with appropriate ownership and permissions.
          :::
        '';
      };

      interface = lib.mkOption {
        default = "127.0.0.1";
        type = lib.types.str;
        description = ''
          Listening interface for the web UI
          Set it to "any" to listen on all available interfaces
        '';
      };

      user = lib.mkOption {
        default = "duplicati";
        type = lib.types.str;
        description = ''
          Duplicati runs as it's own user. It will only be able to backup world-readable files.
          Run as root with special care.
        '';
      };

      parameters = lib.mkOption {
        default = "";
        type = lib.types.lines;
        example = ''
          --webservice-allowedhostnames=*
        '';
        description = ''
          This option can be used to store some or all of the options given to the
          commandline client.
          Each line in this option should be of the format --option=value.
          The options in this file take precedence over the options provided
          through command line arguments.
          <link xlink:href="https://duplicati.readthedocs.io/en/latest/06-advanced-options/#parameters-file">Duplicati docs: parameters-file</link>
        '';
      };

      parametersFile = lib.mkOption {
        default = null;
        type = lib.types.nullOr lib.types.path;
        description = ''
          This file can be used to store some or all of the options given to the
          commandline client.
          Each line in the file option should be of the format --option=value.
          The options in this file take precedence over the options provided
          through command line arguments.
          <link xlink:href="https://duplicati.readthedocs.io/en/latest/06-advanced-options/#parameters-file">Duplicati docs: parameters-file</link>
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    assertions = [
      {
        assertion = !(cfg.parametersFile != null && cfg.parameters != "");
        message = "cannot set both services.duplicati.parameters and services.duplicati.parametersFile at the same time";
      }
    ];

    systemd.services.duplicati = {
      description = "Duplicati backup";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = lib.mkMerge [
        {
          User = cfg.user;
          Group = "duplicati";
          ExecStart = "${cfg.package}/bin/duplicati-server --webservice-interface=${cfg.interface} --webservice-port=${toString cfg.port} --server-datafolder=${cfg.dataDir} --parameters-file=${parametersFile}";
          Restart = "on-failure";
        }
        (lib.mkIf (cfg.dataDir == "/var/lib/duplicati") {
          StateDirectory = "duplicati";
        })
      ];
    };

    users.users = lib.optionalAttrs (cfg.user == "duplicati") {
      duplicati = {
        uid = config.ids.uids.duplicati;
        home = cfg.dataDir;
        group = "duplicati";
      };
    };
    users.groups.duplicati.gid = config.ids.gids.duplicati;

  };
}
