{ lib, config, pkgs, ... }:
let cfg = config.programs.goldwarden;
in
{
  options.programs.goldwarden = {
    enable = lib.mkEnableOption "Goldwarden";
    package = lib.mkPackageOption pkgs "goldwarden" {};
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    programs.firefox.nativeMessagingHosts.packages = [ cfg.package ];

    # see: https://github.com/quexten/goldwarden/blob/main/cmd/setup_linux.go
    systemd.user.services.goldwarden = {
      description = "Goldwarden daemon";
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig.ExecStart = "${lib.getExe cfg.package} daemonize";
    };
  };
}
