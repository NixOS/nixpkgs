{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.hledger-web;
in {
  options.services.hledger-web = {

    enable = mkEnableOption (lib.mdDoc "hledger-web service");

    serveApi = mkEnableOption (lib.mdDoc "serving only the JSON web API, without the web UI");

    host = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = lib.mdDoc ''
        Address to listen on.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 5000;
      example = 80;
      description = lib.mdDoc ''
        Port to listen on.
      '';
    };

    capabilities = {
      view = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Enable the view capability.
        '';
      };
      add = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Enable the add capability.
        '';
      };
      manage = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Enable the manage capability.
        '';
      };
    };

    stateDir = mkOption {
      type = types.path;
      default = "/var/lib/hledger-web";
      description = lib.mdDoc ''
        Path the service has access to. If left as the default value this
        directory will automatically be created before the hledger-web server
        starts, otherwise the sysadmin is responsible for ensuring the
        directory exists with appropriate ownership and permissions.
      '';
    };

    journalFiles = mkOption {
      type = types.listOf types.str;
      default = [ ".hledger.journal" ];
      description = lib.mdDoc ''
        Paths to journal files relative to {option}`services.hledger-web.stateDir`.
      '';
    };

    baseUrl = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "https://example.org";
      description = lib.mdDoc ''
        Base URL, when sharing over a network.
      '';
    };

    extraOptions = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "--forecast" ];
      description = lib.mdDoc ''
        Extra command line arguments to pass to hledger-web.
      '';
    };

  };

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
      capabilityString = with cfg.capabilities; concatStringsSep "," (
        (optional view "view")
        ++ (optional add "add")
        ++ (optional manage "manage")
      );
      serverArgs = with cfg; escapeShellArgs ([
        "--serve"
        "--host=${host}"
        "--port=${toString port}"
        "--capabilities=${capabilityString}"
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
