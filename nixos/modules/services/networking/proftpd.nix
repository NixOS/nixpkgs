{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.proftpd;
  configFile = pkgs.writeText "proftpd.conf" cfg.extraConfig;
in
{
  options.services.proftpd = {
    enable = lib.mkEnableOption "proftpd";
    package = lib.mkPackageOption pkgs "proftpd" { };
    extraConfig = lib.mkOption {
      default = "";
      description = "contents of proftpd config file";
      type = lib.types.lines;
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.proftpd = {
      description = "Proftpd ftp server";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/proftpd -c ${configFile}";
        User = "root";
        Group = "root";
        Type = "forking";
      };
    };
  };
}
