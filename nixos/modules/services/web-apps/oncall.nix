{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.oncall;

in
{
  options.services.oncall = {

    enable = lib.mkEnableOption "Oncall web app";

    hostName = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = "FQDN for the Oncall instance.";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = ''
        Settings to configure web service. See
        <https://codeberg.org/Klasse-Methode/eintopf/src/branch/main/DEPLOYMENT.md>
        for available options.
      '';
      example = lib.literalExpression ''
        {
          EINTOPF_ADDR = ":1234";
          EINTOPF_ADMIN_EMAIL = "admin@example.org";
          EINTOPF_TIMEZONE = "Europe/Berlin";
        }
      '';
    };

    secrets = lib.mkOption {
      type = with lib.types; listOf path;
      description = ''
        A list of files containing the various secrets. Should be in the
        format expected by systemd's `EnvironmentFile` directory.
      '';
      default = [ ];
    };

  };

  config = lib.mkIf cfg.enable {

    services.uwsgi = {
      enable = true;
      plugins = [ "python3" ];
      instance = {
        type = "emperor";
        vassals = {
          oncall = {
            type = "normal";
            pythonPackages = self: [
              pkgs.oncall
            ];
            module = "oncall.wsgi";
            socket = "${config.services.uwsgi.runDir}/oncall.sock";
          };
        };
      };
    };

    services.nginx = {
      enable = lib.mkDefault true;
      virtualHosts."${cfg.hostName}".locations = {
        "/".extraConfig = "proxy_pass http://unix:${config.services.uwsgi.runDir}/oncall.sock";
      };
      proxyTimeout = lib.mkDefault "120s";
    };

  };

  meta.maintainers = with lib.maintainers; [ onny ];

}
