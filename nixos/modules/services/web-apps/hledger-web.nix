{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.hledger-web;
in {
  options.services.hledger-web = {

    enable = mkEnableOption "hledger-web service";

    serveApi = mkEnableOption "Serve only the JSON web API, without the web UI.";

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
      example = "80";
      description = ''
        Port to listen on.
      '';
    };

    capabilities = mkOption {
      type = types.commas;
      default = "view";
      description = ''
        Enable the view, add, and/or manage capabilities. E.g. view,add
      '';
    };

    journalFile = mkOption {
      type = types.path;
      example = "/home/hledger/.hledger.journal";
      description = ''
        Input journal file.
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
  };

  config = mkIf cfg.enable {
    systemd.services.hledger-web = {
      description = "hledger-web - web-app for the hledger accounting tool.";
      documentation = [ https://hledger.org/hledger-web.html ];
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.hledger-web}/bin/hledger-web \
          --host=${cfg.host} \
          --port=${toString cfg.port} \
          --file=${cfg.journalFile}  \
          "--capabilities=${cfg.capabilities}" \
          ${optionalString (cfg.baseUrl != null) "--base-url=${cfg.baseUrl}"} \
          ${optionalString (cfg.serveApi) "--serve-api"}
        '';
        Restart = "always";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ marijanp ];
}
