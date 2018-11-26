{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.concourse-web;
in
{
  options = {
    services.concourse-web = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the Concourse continuous integration web server.
        '';
      };

      user = mkOption {
        default = "concourse";
        type = types.str;
        description = ''
          User the Concourse web server should execute under.
        '';
      };

      group = mkOption {
        default = "concourse";
        type = types.str;
        description = ''
          Group the Concourse web server should execute under.
        '';
      };

      extraGroups = mkOption {
        type = with types; listOf str;
        default = [];
        description = ''
          List of extra groups that Concourse user should be a part of.
        '';
      };

      bind-ip = mkOption {
        default = "0.0.0.0";
        example = "localhost";
        type = types.str;
        description = ''
          Specifies the bind address on which the Concourse web interface listens.
          Defaults to the wildcard IPv4 address.
        '';
      };

      bind-port = mkOption {
        default = 8080;
        type = types.int;
        description = ''
          Specifies the bind port on which the Concourse web interface listens.
        '';
      };

      session-signing-key = mkOption {
        type = types.str;
        example = "/root/session-signing-key";
        description = ''
          Specifies the session signing key.
        '';
      };

      tsa-host-key = mkOption {
        type = types.str;
        example = "/root/tsa-host-key";
        description = ''
          Specifies the TSA host key.
        '';
      };

      tsa-authorized-keys = mkOption {
        type = types.str;
        example = "/root/tsa-authorized-keys";
        description = ''
          Specifies the file containing the list of public keys of workers acceptable by TSA.
        '';
      };

      postgres-host = mkOption {
        default = "127.0.0.1";
        type = with types; nullOr str;
        example = "localhost";
        description = ''
          Specifies the PostgreSQL host containing ATC database.
          Defaults to "127.0.0.1".
        '';
      };

      postgres-port = mkOption {
        default = 5432;
        type = with types; nullOr int;
        example = 5432;
        description = ''
          Specifies the PostgreSQL port containing ATC database.
          Defaults to 5432.
        '';
      };

      postgres-user = mkOption {
        default = "postgres";
        type = types.str;
        example = "postgres";
        description = ''
          Specifies the PostgreSQL user.
        '';
      };

      postgres-password = mkOption {
        default = null;
        type = with types; nullOr str;
        example = "password";
        description = ''
          Specifies the PostgreSQL password.
        '';
      };

      postgres-socket = mkOption {
        default = null;
        type = with types; nullOr str;
        example = "/var/postgres/postgres.sock";
        description = ''
          Specifies the PostgreSQL Unix socket.
        '';
      };

      postgres-database = mkOption {
        default = "atc";
        type = types.str;
        description = ''
          Specifies the PostgreSQL ATC database.
          Defaults to "atc";
        '';
      };

      extraArgs = mkOption {
        default = {};
        type = with types; attrsOf (either (listOf str) str);
        example = ''
          {
            tsa-bind-ip = "0.0.0.0";
            tsa-bind-port = "2222";
          }
        '';
        description = ''
          Specifies the extra arguments supplied to `concourse web` invocation.
          This will be transformed into `systemd` arguments.
        '';
      };

      extraFlags = mkOption {
        default = [];
        type = with types; listOf str;
        example = [ "vault-insecure-skip-verify" ];
        description = ''
          Specifies the extra flags supplied to `concourse web` invocation.
          These flags are command line arguments that does not supply any value and acts like switches.
        '';
      };

      environment = mkOption {
        default = {};
        type = with types; attrsOf str;
        example = ''
          {
            CONCOURSE_TSA_BIND_IP = "0.0.0.0";
            CONCOURSE_TSA_BIND_PORT = "2222";
          }
        '';
        description = ''
          Specifies the extra environment variables supplied to `concourse web` invocation.
        '';
      };
    };
  };

  #### implementation
  config =
  let
    tryEvalListArg = name: value:
      if isList value then
        concatMap (value: [ "--${name}" value ]) value
      else
        [ "--${name}" value ];

    extraFlags =
      map (flag: "--${flag}") cfg.extraFlags;

    extraArgs =
      concatMap
        (x: x)
        (mapAttrsToList tryEvalListArg cfg.extraArgs);

    regularArgs =
      concatMap
        (arg: [ "--${arg}" cfg.${arg} ])
        [
          "bind-ip"
          "bind-port"
          "session-signing-key"
          "tsa-host-key"
          "tsa-authorized-keys"
          "postgres-user"
          "postgres-database"
        ]
      ++ (
        if isNull cfg.postgres-socket then
          [
            "--postgres-host" cfg.postgres-host
            "--postgres-port" cfg.postgres-port
          ]
        else
          [ "--postgres-socket" cfg.postgres-socket ]
      )
      ++ optionals (!isNull cfg.postgres-password) [ "--postgres-password" cfg.postgres-password ];
    args = concatStringsSep " " (map escapeShellArgs [regularArgs extraArgs extraFlags]);
  in
    mkIf cfg.enable {
      users.groups = optional (cfg.group == "concourse") {
        name = "concourse";
        gid = config.ids.gids.concourse;
      };

      users.users = optional (cfg.user == "concourse") {
        name = "concourse";
        description = "concourse user";
        createHome = false;
        group = cfg.group;
        extraGroups = cfg.extraGroups;
        useDefaultShell = false;
        uid = config.ids.uids.concourse;
      };

      systemd.services.concourse-web = {
        description = "Concourse CI Web Server";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig.User = cfg.user;
        environment = config.environment.sessionVariables // cfg.environment;

        serviceConfig.ExecStart = "${pkgs.concourse}/bin/concourse web ${builtins.replaceStrings [ "'" ] [ "\"" ] args}";
      };
    };
}
