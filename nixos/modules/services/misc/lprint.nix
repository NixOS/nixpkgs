{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.services.lprint = {
    enable = lib.mkOption {
      default = false;
      example = true;
      description = ''
        Enable support for label printers using LPrint server.
      '';
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.services.lprint.enable {
    systemd.services.lprint = {
      description = "LPrint Service";
      after = [ "network.target" "nss-lookup.target" ];
      requires = [ "avahi-daemon.socket" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.lprint}/bin/lprint server -o log-file=- -o log-level=info";
        Restart = "on-failure";
      };
    };
    services.avahi.enable = lib.mkDefault true;
    services.avahi.publish.enable = lib.mkDefault true;
    services.avahi.publish.userServices = lib.mkDefault true;
  };
}
