{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.services.cardwired;
  tomlFormat = pkgs.formats.toml { };
in
{
  options.services.cardwired = {
    enable = lib.mkEnableOption "Cardwire eBPF-based GPU manager daemon";

    package = lib.mkPackageOption pkgs "cardwire" { };

    settings = lib.mkOption {
      type = tomlFormat.type;
      default = {
        auto_apply_gpu_state = true;
        experimental_nvidia_block = false;
        battery_auto_switch = false;
      };
      description = ''
        Configuration for `/etc/cardwire.toml`
        See <https://opengamingcollective.github.io/cardwire/getting-started/usage>
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."cardwire/cardwire.toml".source = tomlFormat.generate "cardwire.toml" cfg.settings;

    services.dbus.enable = true;
    services.dbus.packages = [ cfg.package ];
    environment.systemPackages = [ cfg.package ];

    systemd.services.cardwired = {
      description = "Cardwire Daemon";
      after = [
        "dbus.service"
      ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "dbus";
        BusName = "com.github.opengamingcollective.cardwire";
        ExecStart = "${lib.getExe' cfg.package "cardwired"}";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };
  };
}
