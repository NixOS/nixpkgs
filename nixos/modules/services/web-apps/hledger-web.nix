{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.hledger-web;
in {
  options.services.hledger-web = {

    enable = mkEnableOption "hledger-web service";

    serveApi = mkEnableOption "serving only the JSON web API, without the web UI";

    host = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = ''
        Address to listen on.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 5000;
      example = 80;
      description = ''
        Port to listen on.
      '';
    };

    allow = mkOption {
      type = types.enum [ "view" "add" "edit" "sandstorm" ];
      default = "view";
      description = ''
        User's access level for changing data.

        * view: view only permission.
        * add: view and add permissions.
        * edit: view, add, and edit permissions.
        * sandstorm: permissions from the `X-Sandstorm-Permissions` request header.
      '';
    };

    stateDir = mkOption {
      type = types.path;
      default = "/var/lib/hledger-web";
      description = ''
        Path the service has access to. If left as the default value this
        directory will automatically be created before the hledger-web server
        starts, otherwise the sysadmin is responsible for ensuring the
        directory exists with appropriate ownership and permissions.
      '';
    };

    journalFiles = mkOption {
      type = types.listOf types.str;
      default = [ ".hledger.journal" ];
      description = ''
        Paths to journal files relative to {option}`services.hledger-web.stateDir`.
      '';
    };

    baseUrl = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "https://example.org";
      description = ''
        Base URL, when sharing over a network.
      '';
    };

    extraOptions = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "--forecast" ];
      description = ''
        Extra command line arguments to pass to hledger-web.
      '';
    };

  };

  imports = [
    (mkRemovedOptionModule [ "services" "hledger-web" "capabilities" ]
      "This option has been replaced by new option `services.hledger-web.allow`.")
  ];

  config = mkIf cfg.enable {

    users.users.hledger = {
      name = "hledger";
      group = "hledger";
      isSystemUser = true;
      home = cfg.stateDir;
      useDefaultShell = true;
    };

    users.groups.hledger = {};

    systemd.services.hledger-web = let
      serverArgs = with cfg; escapeShellArgs ([
        "--serve"
        "--host=${host}"
        "--port=${toString port}"
        "--allow=${allow}"
        (optionalString (cfg.baseUrl != null) "--base-url=${cfg.baseUrl}")
        (optionalString (cfg.serveApi) "--serve-api")
      ] ++ (map (f: "--file=${stateDir}/${f}") cfg.journalFiles)
        ++ extraOptions);
    in {
      description = "hledger-web - web-app for the hledger accounting tool.";
      documentation = [ "https://hledger.org/hledger-web.html" ];
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ];
      serviceConfig = mkMerge [
        {
          ExecStart = "${pkgs.hledger-web}/bin/hledger-web ${serverArgs}";
          Restart = "always";
          WorkingDirectory = cfg.stateDir;
          User = "hledger";
          Group = "hledger";
          PrivateTmp = true;
        }
        (mkIf (cfg.stateDir == "/var/lib/hledger-web") {
          StateDirectory = "hledger-web";
        })
      ];
    };

  };

  meta.maintainers = with lib.maintainers; [ marijanp erictapen ];
}
