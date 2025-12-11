{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.services.byedpi;
in
{
  options.services.byedpi = {
    enable = lib.mkEnableOption "the ByeDPI service";
    package = lib.mkPackageOption pkgs "byedpi" { };
    extraArgs = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      example = [
        "--split"
        "1"
        "--disorder"
        "3+s"
        "--mod-http=h,d"
        "--auto=torst"
        "--tlsrec"
        "1+s"
      ];
      description = "Extra command line arguments.";
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.byedpi = {
      description = "ByeDPI";
      wantedBy = [ "default.target" ];
      wants = [ "network-online.target" ];
      after = [
        "network-online.target"
        "nss-lookup.target"
      ];
      serviceConfig = {
        ExecStart = lib.escapeShellArgs ([ (lib.getExe cfg.package) ] ++ cfg.extraArgs);
        NoNewPrivileges = "yes";
        StandardOutput = "null";
        StandardError = "journal";
        TimeoutStopSec = "5s";
        PrivateTmp = "true";
        ProtectSystem = "full";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ wozrer ];
}
