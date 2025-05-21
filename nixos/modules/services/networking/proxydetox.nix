{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.proxydetox;
in

{

  options.services.proxydetox = {

    enable = lib.mkEnableOption ''
      proxydetox, which can evaluate PAC files and
      forward to the correct parent proxy with authentication
    '';

    rc = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        Contents of /etc/proxydetox/proxydetoxrc, default
        additional command line options
      '';
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    systemd.user.services.proxydetox = {
      description = "proxydetox is HTTP proxy";
      after = [ "network.target" ];
      wantedBy = [ "default.target" ];
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = ''
          ${pkgs.proxydetox}/bin/proxydetox
        '';
      };
    };

    environment.etc."proxydetox/proxydetoxrc".text = cfg.rc;
  };

  meta.maintainers = with lib.maintainers; [
    maxmosk
    shved
  ];
}
