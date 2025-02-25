{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.hayabusa;

in
{
  meta.maintainers = with maintainers; [ crinklywrappr ];

  options.services.hayabusa = {
    enable = mkEnableOption "Hayabusa, a configurable sysfetch that uses a daemon to cache sysinfo and run fast!";

    package = mkOption {
      type = types.package;
      default = pkgs.hayabusa;
      description = "The package to use for hayabusa";
    };

    flags = mkOption {
      type = types.str;
      default = "-d";
      description = "Flags for the hayabusa daemon";
    };
  };

  config = mkIf cfg.enable {
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
          ExecStart = "${cfg.package}/bin/hayabusa ${cfg.flags}";
        };
      };
    };
  };

}
