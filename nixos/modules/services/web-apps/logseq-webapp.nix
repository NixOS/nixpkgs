{
  lib,
  pkgs,
  config,
  utils,
  ...
}:
let

  cfg = config.services.logseq-webapp;

in
{

  options.services.logseq-webapp = {

    enable = lib.mkEnableOption (lib.mdDoc "Local-first, non-linear, outliner notebook");

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = lib.mdDoc ''
        The hostname on which to listen.
      '';
    };

  };

  config = lib.mkIf cfg.enable {

    services.caddy = {
      enable = lib.mkDefault true;
      virtualHosts."http://${cfg.hostname}".extraConfig = ''
        file_server
        root * ${pkgs.logseq-webapp}
      '';
    };

  };

  meta.maintainers = with lib.maintainers; [ onny ];

}
