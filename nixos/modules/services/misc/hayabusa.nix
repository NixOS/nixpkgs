{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.hayabusa;
in
{
  meta.maintainers = with lib.maintainers; [ crinklywrappr ];

  options.services.hayabusa = {
    enable = lib.mkEnableOption "Hayabusa, a configurable sysfetch that uses a daemon to cache sysinfo and run fast!";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.hayabusa;
      description = "The package to use for hayabusa";
    };

    flags = lib.mkOption {
      type = lib.types.str;
      default = "-d";
      description = "Flags for the hayabusa daemon";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd = {
      services.hayabusa = {
        description = "the hayabusa daemon";
        after = [ "network.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Restart = "always";
          Type = "simple";
          ExecStart = "${lib.getExe cfg.package} ${cfg.flags}";
        };
      };
    };
  };
}
